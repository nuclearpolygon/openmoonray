# syntax=docker.io/docker/dockerfile:1.7-labs
FROM  nvidia/cuda:11.8.0-devel-ubuntu22.04 AS openmoonray_install_deps
SHELL ["/bin/bash", "-c"]
RUN apt update
WORKDIR /openmoonray

# install optix
RUN --mount=type=bind,source=./NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh,target=/installers/NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh \
 sh /installers/NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64.sh --skip-license --prefix=/usr

COPY --exclude=./building --exclude=./Dockerfile --exclude=./NVIDIA* . .

# install packages
COPY ./building/Ubuntu22.04/install_packages.sh ./building/Ubuntu22.04/install_packages.sh
RUN source ./building/Ubuntu22.04/install_packages.sh


ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64"
ENV PATH="/installs/cmake-3.23.1-linux-x86_64/bin:/usr/local/cuda/bin:$PATH"

# build vdb
FROM openmoonray_install_deps AS openmoonray_build_vdb

WORKDIR /installs
RUN /openmoonray/build_openvdb.sh

# build dependencies
FROM openmoonray_build_vdb AS openmoonray_build_deps

COPY ./building/ /openmoonray/building/
WORKDIR /build
RUN cmake /openmoonray/building/Ubuntu22.04
RUN cmake --build . -- -j $(nproc)
RUN mkdir /openmoonray_install
WORKDIR /openmoonray_build

# build openmoonray
FROM openmoonray_build_deps AS openmoonray_build

# -DCMAKE_ISPC_FLAGS="--target=x86_64"
RUN cmake /openmoonray
RUN cmake --build . -- -j $(nproc)
RUN cmake --install . --prefix /openmoonray_install
