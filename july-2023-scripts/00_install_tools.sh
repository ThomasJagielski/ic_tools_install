#!/bin/sh -f

export GAW_LOC=$PWD/gaw3-20220315.tar.gz
export GAW_MAKEFILE=$PWD/gaw_po_Makefile.in.in
export IC_DESIGN_TOOL_SRC=$HOME/ic_design_tools

mkdir -p $IC_DESIGN_TOOL_SRC
cd $IC_DESIGN_TOOL_SRC

export START_PWD=$PWD
echo $START_PWD

echo "Installing dependencies."

# Install Docker for Openlane
sudo apt install curl -y
sudo apt install gnome-terminal -y
sudo apt remove docker-desktop -y
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install python3.10-venv -y
# sudo apt install python3-venv -y

# Test docker by running "sudo docker run hello-world"

# Install other dependencies
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y vim htop git
sudo apt-get install -y build-essential htop
sudo apt-get install -y libtool automake autoconf flex bison texinfo
sudo apt-get install -y libx11-dev libxaw7-dev libreadline-dev
sudo apt-get install -y m4 vim tcl-dev tk-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev tcsh csh libx11-dev libcairo2-dev libncurses-dev
sudo apt-get install -y python3 python3-pip libgsl-dev libgtk-3-dev cmake
sudo apt-get install -y build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev

sudo apt-get install -y gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool autoconf octave liboctave-dev epstool transfig paraview
sudo apt-get install -y libhdf5-dev libvtk7-dev libboost-all-dev libcgal-dev libtinyxml-dev qtbase5-dev libvtk7-qt-dev
sudo apt-get install -y octave liboctave-dev
sudo apt-get install -y gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool
sudo apt-get install -y libopenmpi-dev 
sudo apt install gettext -y 

# For gaw3
sudo apt-get install -y libgtk-3-dev

echo "Downloading files."
wget -O ngspice-40.tar.gz https://versaweb.dl.sourceforge.net/project/ngspice/ng-spice-rework/40/ngspice-40.tar.gz
#wget http://opencircuitdesign.com/magic/archive/magic-8.3.120.tgz
#wget http://opencircuitdesign.com/netgen/archive/netgen-1.5.165.tgz
#wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.26.8-1_amd64.deb
#wget http://opencircuitdesign.com/qflow/archive/qflow-1.4.90.tgz
#wget http://opencircuitdesign.com/qrouter/archive/qrouter-1.4.83.tgz
#wget http://opencircuitdesign.com/xcircuit/archive/xcircuit-3.10.30.tgz

echo "## Installing tools"
echo "# Installing ngspice"
tar zxvf ngspice-40.tar.gz
cd ngspice-40
mkdir release
cd release
../configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readlines=yes --disable-debug
make
sudo make install
cd $START_PWD

cd ngspice-40
mkdir build-lib
cd build-lib
../configure --with-x --enable-xspice --enable-cider --enable-openmp --disable-debug --with-#ngshared
make
sudo make install
cd $START_PWD

echo "# Installing ngspice complete."
echo "# Installing magic"
git clone git://opencircuitdesign.com/magic 
cd magic
./configure
make
sudo make install
cd $START_PWD

echo "# Installing netgen"
git clone git://opencircuitdesign.com/netgen
cd netgen
./configure
make
sudo make install
cd $START_PWD

echo "# Installing gaw3"
# Refer to: http://web02.gonzaga.edu/faculty/talarico/vlsi/install2.html
# Download from: https://www.rvq.fr/linux/gaw.php
# wget https://www.rvq.fr/php/ndl.php
# https://www.rvq.fr/php/ndl.php?id=gaw.?-.*
#cp $GAW_LOC $IC_DESIGN_TOOL_SRC
#tar zxvf gaw3-20220315.tar.gz
#cd gaw3-20220315/
#./configure
#make
#sudo make install

# -- GIT version of install - broken last time checked -- 
git clone https://github.com/StefanSchippers/xschem-gaw.git
cd xschem-gaw
cp $GAW_MAKEFILE ./po/Makefile.in.in
aclocal && automake --add-missing && autoconf
./configure
make
sudo make install
#git checkout 2a1fc97bcc3081af72fc37a8bc52bc4632e176b2
#./configure
#make -j$(nproc)
#sudo make install
cd $START_PWD


echo "# Installing xschem"
sudo apt install -y xterm graphicsmagick ghostscript
git clone https://github.com/StefanSchippers/xschem.git
cd xschem
./configure
make -j$(nproc)
sudo make install
cd $START_PWD


echo "# Installing irsim"
git clone git://opencircuitdesign.com/irsim
cd irsim
./configure
make
sudo make install
cd $START_PWD

echo "# Installing Openlane"
# git clone https://github.com/The-OpenROAD-Project/OpenLane
# cd OpenLane
# sudo make
# sudo make test
# cd $START_PWD

cd $START_PWD
rm *.tar.gz

magic &
app_pid=$!
sleep 5
kill $app_pid

xschem &
app_pid=$!
sleep 5
kill $app_pid

# -- NOT USED IN CURRENT DESIGN FLOW -- NOT INSTALLED --

# echo "# Installing klayout"
# sudo apt install klayout -y
# sudo dpkg -i ./klayout_0.26.8-1_amd64.deb
# sudo apt-get install -f -y

# echo "# Installing xcircuit"
# git clone git://opencircuitdesign.com/xcircuit 
# cd xcircuit
# ./configure && make && sudo make install
# cd $START_PWD

#echo "# Install Yoss"
#git clone https://github.com/YosysHQ/yosys.git
#cd yosys
#make config-gcc
#make
#sudo make install
#cd $START_PWD

#echo "# Install graywolf"
#git clone https://github.com/rubund/graywolf.git
#cd graywolf
#mkdir build
#cd build
#cmake ..
#make
#sudo make install
#cd $START_PWD

#echo "# Installing qrouter"
#tar zxvf qrouter-1.4.83.tgz
#cd qrouter-1.4.83
#./configure
#make
#sudo make install


#echo "# Installing qflow"
#tar zxvf qflow-1.4.90.tgz
#cd qflow-1.4.90
#./configure
#make
#sudo make install
#cd $START_PWD

#echo "## Installing EMS"
# git clone --recursive https://github.com/thliebig/openEMS-Project.git
# cd openEMS-Project
# sudo ./update_openEMS.sh ~/opt/openEMS --with-hyp2mat --with-CTB --with-MPI
#sudo apt install -y libtinyxml-dev libhdf5-serial-dev libcgal-dev vtk6 libvtk6-qt-dev
#sudo apt install -y cython3 build-essential cython3 python3-numpy python3-matplotlib
#sudo apt install -y python3-scipy python3-h5py
#echo "$PWD"

#git clone https://github.com/thliebig/openEMS-Project.git
#cd openEMS-Project
#git submodule init
#git submodule update

#export OPENEMS=/opt/openems
#sudo ./update_openEMS.sh $OPENEMS
#cd CSXCAD/python; python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib; sudo python3 setup.py install; cd ../..
#cd openEMS/python; python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib; sudo python3 setup.py install; cd ../..
