#Author: Yue Ding
#Usage: create an empty directory then copy gromacs-2022.5.tar.gz, plumed-src-2.8.3.tgz and Dockerfile to this folder.
#       run command: docker build -t gmx:2022.5 .

FROM ubuntu:20.04

COPY ./gromacs-2022.5.tar.gz /srv
COPY ./plumed-src-2.8.3.tgz /srv

RUN apt-get update \
	&& apt-get install -y cmake g++ gcc libblas-dev xxd patch\
	&& apt-get clean 

#install plumed
WORKDIR /srv
RUN tar -zxf plumed-src-2.8.3.tgz \
	&& cd plumed-2.8.3 \
	&& ./configure --enable-modules=all --prefix=/srv/plumed \
	&& make -j6 \
	&& make install \
	&& make clean

ENV PATH="$PATH:/srv/plumed/bin"
ENV LIBRARY_PATH="$LIBRARY_PATH:/srv/plumed/lib"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/srv/plumed/lib"
ENV PLUMED_KERNEL="/srv/plumed/lib/libplumedKernel.so"

#install gmx
WORKDIR /srv
RUN tar -zxf gromacs-2022.5.tar.gz \
	&& cd ./gromacs-2022.5 \
	&& echo 4 | plumed patch -p \
    && mkdir build \
    && cd ./build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/srv/gmx202205 -DGMX_BUILD_OWN_FFTW=ON \
	&& make -j6 install \
	&& make clean \
	&& rm /srv/gromacs-2022.5.tar.gz /srv/plumed-src-2.8.3.tgz

ENV GMXBIN="/srv/gmx202205/bin"
ENV GMXDATA="/srv/gmx202205/share/gromacs"
ENV GMXLDLIB="/srv/ggmx202205/lib64"
ENV GMXMAN="/srv/gmx202205/share/man"
ENV GROMACS_DIR="/srv/gmx202205"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/srv/gmx202205/lib64"
ENV MANPATH="/srv/gmx202205/share/man"
ENV PATH="/srv/gmx202205/bin:$PATH"
ENV PKG_CONFIG_PATH="/srv/gmx202205/lib64/pkgconfig"

WORKDIR /home/gmx/Gromacs


