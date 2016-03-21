FROM ubuntu:14.04
MAINTAINER  rskjtwp@gmail.com
RUN sed -i.bak -e 's%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g' /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y build-essential vim git zsh wget libgmp3-dev libmpfr-dev libmpc-dev gawk texinfo

WORKDIR /tmp

ENV BINUTILS_VERSION binutils-2.25
ENV GCC_VERSION gcc-4.8.5
ENV LINUX_KERNEL_VERSION linux-4.2
ENV GLIBC_VERSION glibc-2.23

RUN wget -nc http://ftp.jaist.ac.jp/pub/GNU/binutils/$BINUTILS_VERSION.tar.gz
RUN wget -nc http://ftp.jaist.ac.jp/pub/GNU/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
RUN wget -nc http://ftp.jaist.ac.jp/pub/Linux/kernel.org/linux/kernel/v4.x/$LINUX_KERNEL_VERSION.tar.gz
RUN wget -nc http://ftp.jaist.ac.jp/pub/GNU/glibc/$GLIBC_VERSION.tar.gz

RUN tar xvzof $BINUTILS_VERSION.tar.gz
RUN tar xvzof $GCC_VERSION.tar.gz
RUN tar xvzof $LINUX_KERNEL_VERSION.tar.gz
RUN tar xvzof $GLIBC_VERSION.tar.gz

WORKDIR /tmp/$GCC_VERSION
RUN ./contrib/download_prerequisites

WORKDIR /tmp
ADD build.sh /tmp
RUN chmod +x build.sh

## install gcc
RUN ./build.sh arm-linux-gnueabi arm
RUN ./build.sh arm-linux-gnueabihf arm
RUN ./build.sh aarch64-linux-gnu arm64
RUN ./build.sh powerpc-linux-gnu powerpc
RUN ./build.sh powerpc64le-linux-gnu powerpc
RUN ./build.sh mips-linux-gnu mips
RUN ./build.sh mipsel-linux-gnu mips
RUN ./build.sh mips64el-linux-gnuabi64 mips
RUN ./build.sh alpha-linux-gnu alpha
RUN ./build.sh s390x-linux-gnu s390
RUN ./build.sh m68k-linux-gnu m68k
RUN ./build.sh i686-linux-gnu x86
# RUN ./build.sh x86_64-linux-gnu x86
# RUN ./build.sh cris-linux-gnu cris
RUN ./build.sh sh4-linux-gnu sh
# RUN ./build.sh sparc-linux-gnu sparc
# RUN ./build.sh sparc64-linux-gnu sparc

# ALL BINUTILS
ADD build-binutils-all.sh /tmp
RUN chmod +x build-binutils-all.sh
RUN ./build-binutils-all.sh

# QEMU
RUN apt-get install -y qemu-user-static file

ENV GDB_VERSION 7.11
ENV PREFIX /usr/local

# GDB
RUN wget -nc http://ftp.jaist.ac.jp/pub/GNU/gdb/gdb-$GDB_VERSION.tar.gz
RUN tar xvzof gdb-$GDB_VERSION.tar.gz
ADD build-gdb.sh /tmp
RUN chmod +x /tmp/build-gdb.sh

RUN ./build-gdb.sh alpha-elf
# RUN ./build-gdb.sh arc-elf
RUN ./build-gdb.sh arm-elf
RUN ./build-gdb.sh avr-elf
RUN ./build-gdb.sh bfin-elf
RUN ./build-gdb.sh cris-elf
# RUN ./build-gdb.sh crx-elf
RUN ./build-gdb.sh fr30-elf
RUN ./build-gdb.sh frv-elf
RUN ./build-gdb.sh h8300-elf
RUN ./build-gdb.sh m32c-elf
RUN ./build-gdb.sh m32r-elf
RUN ./build-gdb.sh m6811-elf
# RUN ./build-gdb.sh mcore-elf
RUN ./build-gdb.sh mips64-elf
RUN ./build-gdb.sh mips16-elf
RUN ./build-gdb.sh mips-elf
# RUN ./build-gdb.sh moxie-elf
RUN ./build-gdb.sh mn10300-elf
RUN ./build-gdb.sh powerpc-elf
RUN ./build-gdb.sh sh-elf
# RUN ./build-gdb.sh sh64-elf
# RUN ./build-gdb.sh sparc-elf
RUN ./build-gdb.sh v850-elf
RUN ./build-gdb.sh vax-netbsdelf

# Cleanup
# RUN rm -rf /tmp
RUN apt-get clean

CMD ["/bin/bash"]
