[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = 0
  ymin = 0
  xmax = 30.0
  ymax = 30.0
[]

[Variables]
  [./c]
    [./InitialCondition]
      type = BoundingBoxIC
      x1 = 0
      y1 = 0
      x2 = 15.0
      y2= 30.0
      #radius = 3
      #int_width = 1
      inside = 1
      outside = 0
    [../]
  [../]
[]

[Kernels]
  [./cres]
    type = MatAnisoDiffusion
    D_name = D
    variable = c
  [../]
  [./time]
    type = TimeDerivative
    variable = c
  [../]
[]

[Materials]
  [./D]
    type = ConstantAnisotropicMobility
    tensor = '.505 .495 .0
              .495 .505 .0
              .0   .0   .0'
    M_name = D
  [../]
[]

[Preconditioning]
  [./SMP]
   type = SMP
   full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  scheme = bdf2

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu'

  l_max_its = 30
  l_tol = 1.0e-4
  nl_max_its = 50
  nl_rel_tol = 1.0e-10

  dt = 1.0
  num_steps = 20
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
