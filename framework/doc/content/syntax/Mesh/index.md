# Mesh System

## Overview

In general, MOOSE is not designed for generating finite element meshes. Generally,
[CUBIT](https://cubit.sandia.gov/) from [Sandia National Laboratories](http://www.sandia.gov/) is
recommended for creating meshes, especially complex geometries, for use in MOOSE. CUBIT can be
licensed from CSimSoft for a fee depending that varies based on the type of organization and work
being performed. Other mesh generators can work as long as they output a file format that is
supported by the [FileMesh](/FileMesh.md) object.

## Example Syntax and Mesh Objects

Mesh settings are applied with the `[Mesh]` of the input files, for example the basic input file
syntax for reading a file from a mesh is shown below. For additional information on the other types
of Mesh objects refer to the individual object pages listed below.

!listing test/tests/auxkernels/solution_aux/build.i block=Mesh

!syntax list /Mesh objects=True actions=False subsystems=False

!syntax list /Mesh objects=False actions=False subsystems=True

!syntax list /Mesh objects=False actions=True subsystems=False

## Named Entity Support

Human-readable names can be assigned to blocks, sidesets, and nodesets. These names will be
automatically read in and can be used throughout the input file. Mesh generators such as CUBIT will
generally provide the capability internally.  Any parameter that takes entity IDs in the input file
will accept either numbers or "names". Names can also be assigned to IDs on-the-fly in existing
meshes to ease input file maintenance (see example). On-the-fly names will also be written to
Exodus/XDA/XDR files. An illustration for mesh in exodus file format.

!listing test/tests/mesh/named_entities/name_on_the_fly.i block=Mesh

## Replicated and Distributed Mesh id=replicated-and-distributed-mesh

The core of the mesh capabilities are derived from [libMesh], which has two underlying
parallel mesh formats: "replicated" and "distributed".

The replicated mesh format is the default format for MOOSE and is the most appropriate format to
utilize for nearly all simulations. In parallel, the replicated format copies the complete mesh to
all processors allowing for efficient access to the geometry elements.

The distributed mesh format is useful when the mesh data structure dominates memory usage. Only the
pieces of the mesh "owned" by a processor are actually stored on the processor. If the mesh is too
large to read in on a single processor, it can be split prior to the simulation.

!alert note
Both the "replicated" and "distributed" mesh formats are parallel with respect to the execution of
the finite element assembly and solve. In both types the solution data is distributed, which is
the portion of the simulation that usually dominates memory demands.

## Mesh splitting

For large meshes, MOOSE provides the ability to pre-split a mesh for use in the the "distributed"
format/mode.  To split and use a mesh for distributed runs:

```
// For input files with a file-based mesh:
$ moose-app-opt -i your_input-file.i --split-mesh 500,1000,2000 // comma-separated list of split configurations
Splitting 500 ways...
    - writing 500 files per process...
Splitting 1000 ways...
    - writing 1000 files per process...
...

// MOOSE automatically selects the pre-split mesh configuration based on MPI procs
$ mpiexec -n 1000 moose-app-opt -i your_input-file.i --use-split
```

For more details see "[Mesh Splitting](/Mesh/splitting.md)".

## Displaced Mesh

Calculations can take place in either the initial mesh configuration or, when requested, the
"displaced" configuration. To enable displacements, provide a vector of displacement variable names
for each spatial dimension in the 'displacements' parameters within the Mesh block.

!listing modules/tensor_mechanics/test/tests/truss/truss_2d.i block=Mesh

Once enabled, the any object that should operate on the displaced configuration should set the
"use_displaced_mesh" to true. For example, the following snippet enables the computation of a
[Postprocessor](/Postprocessors/index.md) with and without the displaced configuration.

!listing test/tests/postprocessors/displaced_mesh/elemental.i block=Postprocessors
