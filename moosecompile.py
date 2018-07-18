# -*- coding: utf-8 -*-
"""
Created on Mon Jul 16 10:24:30 2018

@author: andylau

To compile moose and its submodules directly 
"""

import os 
import subprocess

moose_dir = os.getcwd()
moose_mol_dir = os.path.join(moose_dir,'modules')

rebuild_libmesh=subprocess.call("./scripts/update_and_rebuild_libmesh.sh", shell=True)

os.chdir(os.path.join(moose_dir,'test'))
subprocess.call("make -j 8", shell=True)
subprocess.call("./run_tests -j 8", shell=True)

moduleslist=['phase_field','tensor_mechanics','xfem','heat_conduction']

for i in range(len(moduleslist)):
    os.chdir(os.path.join(moose_mol_dir,moduleslist[i]))
    subprocess.call("make -j 4", shell=True)
    subprocess.call("./run_tests -j 4", shell=True)
