# Copyright 2023-2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Install Rocky Linux 9 packages for building MoonRay
# source this script in bash

install_qt=1
install_cuda=1
install_cgroup=1
for i in "$@"
do
case ${i,,} in
    --noqt|-noqt)
        install_qt=0
    ;;
    --nocuda|-nocuda)
        install_cuda=0
    ;;
    --nocgroup|-nocgroup)
        install_cgroup=0
    ;;
    *)
        echo "Unknown option: $i"
        return 1
    ;;
esac
done


#apt install -y epel-release
#apt config-manager --enable crb
apt install -y git wget tar
apt install -y g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev apt-utils
apt install -y libssl-dev libcurl4-openssl-dev

# not required if you are not building with GPU support
#if [ $install_cuda -eq 1 ]
#then
##    apt config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
#    wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
#    sh cuda_11.8.0_520.61.05_linux.run
#fi



apt install -y libglvnd0

apt install -y gcc-11 g++

apt install -y bison flex wget git python3 python3-dev patch \
               libgif-dev libmng-dev libtiff-dev libjpeg-dev \
               libatomic1 uuid-dev libssl-dev curl \
               libfreetype-dev zlib1g-dev

apt install -y lsb-release
apt install -y libjemalloc-dev
export DEBIAN_FRONTEND=noninteractive
apt install -y libmkl-dev
unset DEBIAN_FRONTEND



mkdir -p /installs/{bin,lib,include}
cd /installs
mkdir /installers

if [ $install_cgroup -eq 1 ]
then
#    wget https://kojihub.stream.centos.org/kojifiles/packages/libcgroup/0.42.2/5.el9/x86_64/libcgroup-0.42.2-5.el9.x86_64.rpm
#    wget https://kojihub.stream.centos.org/kojifiles/packages/libcgroup/0.42.2/5.el9/x86_64/libcgroup-devel-0.42.2-5.el9.x86_64.rpm
    apt install -y libcgroup1
    apt install -y libcgroup-dev
fi

wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz
tar xzf cmake-3.23.1-linux-x86_64.tar.gz

apt install -y libblosc1 libblosc-dev #1.21.2
apt install -y libboost-all-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-python-dev libboost-program-options-dev libboost-regex-dev libboost-thread-dev libboost-system-dev libboost-dev #1.75.0
apt install -y liblua5.4-0 liblua5.4-dev lua5.4 #5.4.4
#apt install -y libopenvdb-tools python3-openvdb libopenvdb-dev #9.1.0
apt install -y libboost-iostreams-dev libtbb2-dev

#git clone https://github.com/AcademySoftwareFoundation/openvdb.git
#cd ./openvdb
#git checkout v9.1.0
#mkdir ./build
#cd ./build
#cmake -DCMAKE_INSTALL_PREFIX=/usr ..
#make -j20
#make install

apt install -y libtbb2 libtbb2-dev #2020.3
apt install -y liblog4cplus-2.0.5 liblog4cplus-dev #2.0.5
apt install -y libcppunit-1.15-0 libcppunit-dev #1.15.1
apt install -y libmicrohttpd12 libmicrohttpd-dev #0.9.72

# not required if you are not building the GUI apps
if [ $install_qt -eq 1 ]
then
    apt install -y qtbase5-dev qtscript5-dev
fi

cd /openmoonray
export PATH=/installs/cmake-3.23.1-linux-x86_64/bin:/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
