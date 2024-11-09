#!/bin/bash

git clone https://github.com/AcademySoftwareFoundation/openvdb.git
cd ./openvdb
git checkout v9.1.0
mkdir ./build
cd ./build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j $(nproc)
make install