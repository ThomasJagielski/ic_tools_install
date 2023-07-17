#!/usr/bin/env python3

import os, sys

if len(sys.argv) != 3:
    print('lvs: You must specify two netlist filenames to compare.')
    sys.exit(1)

os.system('netgen -batch lvs {} {} ~/skywater/open_pdks/sky130/sky130A/libs.tech/netgen/sky130A_setup.tcl'.format(sys.argv[1], sys.argv[2]))
sys.exit(0)

