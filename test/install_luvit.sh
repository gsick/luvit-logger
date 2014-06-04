#!/bin/sh
set -ex
cd /home/travis/build/gsick
wget http://luvit.io/dist/latest/luvit-0.7.0.tar.gz
tar xf luvit-0.7.0.tar.gz
cd luvit-0.7.0
make --silent PREFIX=/home/travis/build/gsick
make install PREFIX=/home/travis/build/gsick
#export PATH=$PATH:/home/travis/build/gsick/bin
cd /home/travis/build/gsick/luvit-logger