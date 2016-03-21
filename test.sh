#!/bin/sh

sudo apt-get install -y unzip

wget https://github.com/SECCON/SECCON2015_online_CTF/raw/master/Binary/200_Individual%20Elebin/Individual_Elebin.zip
unzip Individual_Elebin.zip
cd Individual_Elebin/
ls
file *
./1.bin; echo
