#!/bin/sh -f

cd
mkdir skywater
cd skywater
git clone https://github.com/google/skywater-pdk
cd skywater-pdk
git submodule init libraries/sky130_fd_io/latest
git submodule init libraries/sky130_fd_pr/latest
git submodule init libraries/sky130_fd_sc_hd/latest
git submodule init libraries/sky130_fd_sc_hdll/latest
git submodule init libraries/sky130_fd_sc_hs/latest
git submodule init libraries/sky130_fd_sc_ms/latest
git submodule init libraries/sky130_fd_sc_ls/latest
git submodule init libraries/sky130_fd_sc_lp/latest
git submodule init libraries/sky130_fd_sc_hvl/latest
git submodule update
make timing 
cd ~/skywater/
git clone git://opencircuitdesign.com/open_pdks
cd open_pdks
git checkout open_pdks-1.0
./configure --enable-sky130-pdk=$HOME/skywater/skywater-pdk/libraries --with-sky130-variants=A --with-ef-style
# ./configure --enable-sky130-pdk=$HOME/skywater/skywater-pdk/libraries --with-sky130-variants=all --with-ef-style
make
sudo make install
#cd sky130
#make
#make install
cd ~/skywater

echo "# Installing xschem sky130"
git clone https://github.com/StefanSchippers/xschem_sky130.git

#echo "# Installing sample designs"
#mkdir samples
#cd samples
#git clone https://github.com/bluecmd/learn-sky130.git
#git clone https://github.com/westonb/sky130-analog.git
#git clone https://github.com/yrrapt/amsat_txrx_ic.git
#git clone https://github.com/diadatp/sky130_rf_tools.git
#git clone https://github.com/pepijndevos/sky130-experiments.git
#git clone https://github.com/efabless/caravel.git

