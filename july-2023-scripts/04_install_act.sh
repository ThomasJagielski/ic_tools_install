#!/bin/bash

sudo apt install cmake bison flex libedit-dev zlib1g m4 libboost-all-dev libfmt-dev llvm -y

cd $ACT_HOME
git clone https://github.com/asyncvlsi/actflow.git
cd actflow
git submodule update --init --recursive
./build

# Build actsim with xyce
cd actsim/xyce-bits/
g++ -std=c++17 -I. -I$ACT_HOME/include -c N_CIR_XyceCInterface.C
ar ruv libxycecinterface.a N_CIR_XyceCInterface.o
ranlib libxycecinterface.a
cp libxycecinterface.a $ACT_HOME/lib
cp N_CIR_XyceCInterface.h $ACT_HOME/include
./grab_xyce.sh $ACT_HOME/xyce/Xyce/build