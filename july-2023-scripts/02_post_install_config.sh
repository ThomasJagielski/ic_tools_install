#!/bin/sh -f

# Copy MADVLSI library for xschem
sudo cp -R madvlsi /usr/local/share/xschem/xschem_library/

# Copy xschemrc file to correct location
cp xschemrc ~/.xschem/

# Magic config
cp ~/skywater/open_pdks/sky130/sky130A/libs.tech/magic/current/sky130A.magicrc ~/.magicrc

# Xyce skywater files
cp ./sky130-xyce.tar.xz ~/skywater
cd ~/skywater
tar -xf sky130-xyce.tar.xz
rm -rf sky130-xyce.tar.xz

# Apply patch to pdk libraries
cd ~/skywater/skywater-pdk/libraries
cp -a sky130_fd_pr sky130_fd_pr_ngspice
cd sky130_fd_pr_ngspice/
cd latest/
patch -p2 < $HOME/skywater/xschem_sky130/sky130_fd_pr.patch
