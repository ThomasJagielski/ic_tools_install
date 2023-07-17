#!/bin/sh

mkdir -p $ACT_HOME
cd $ACT_HOME
mkdir -p xyce
cd xyce

export START_PWD=$PWD
echo $START_PWD

sudo apt-get -q install -y libedit-dev zlib1g-dev m4 build-essential libsuitesparse-dev libboost-all-dev flex bison git -y
sudo apt install cmake bison flex libedit-dev zlib1g m4 libboost-all-dev libfmt-dev llvm -y

sudo apt-get install -y gfortran bison flex libfl-dev libtool
sudo apt-get install -y libfftw3-dev libsuitesparse-dev libblas-dev liblapack-dev
sudo apt-get install -y libopenmpi-dev openmpi-bin
sudo apt-get install -y libtool-bin

git clone https://github.com/trilinos/trilinos
cd trilinos
git checkout trilinos-release-12-12-branch
mkdir -p build 
cd build

cmake -G "Unix Makefiles" -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_CXX_FLAGS="-O3 -fPIC" -DCMAKE_C_FLAGS="-O3 -fPIC" -DCMAKE_Fortran_FLAGS="-O3 -fPIC" -DCMAKE_INSTALL_PREFIX=$ACT_HOME -DCMAKE_MAKE_PROGRAM="make" -DTrilinos_ENABLE_NOX=ON   -DNOX_ENABLE_LOCA=ON -DTrilinos_ENABLE_EpetraExt=ON   -DEpetraExt_BUILD_BTF=ON   -DEpetraExt_BUILD_EXPERIMENTAL=ON   -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON -DTrilinos_ENABLE_TrilinosCouplings=ON -DTrilinos_ENABLE_Ifpack=ON -DTrilinos_ENABLE_AztecOO=ON -DTrilinos_ENABLE_Belos=ON -DTrilinos_ENABLE_Teuchos=ON -DTeuchos_ENABLE_COMPLEX=ON -DTrilinos_ENABLE_Amesos=ON   -DAmesos_ENABLE_KLU=ON -DTrilinos_ENABLE_Amesos2=ON  -DAmesos2_ENABLE_KLU2=ON  -DAmesos2_ENABLE_Basker=ON -DTrilinos_ENABLE_Sacado=ON -DTrilinos_ENABLE_Stokhos=ON -DTrilinos_ENABLE_Kokkos=ON -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF -DTrilinos_ENABLE_CXX11=ON -DTPL_ENABLE_AMD=ON -DAMD_LIBRARY_DIRS="/lib/${TARGETARCH}-linux-gnu/" -DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" -DTPL_ENABLE_BLAS=ON -DTPL_ENABLE_LAPACK=ON ..

make -j 3
make install # buildkit

cd $START_PWD

git clone https://github.com/asyncvlsi/Xyce/ 
cd Xyce
git checkout 45685cc71754ad7b71bc0b32e0a09f99c29e5401
mkdir build
cd build 

cmake -DCMAKE_INSTALL_PREFIX=$ACT_HOME .. 

make -j 3 
make install # buildkit

make xycecinterface
# make install
sudo make DESTDIR=$ACT_HOME install
