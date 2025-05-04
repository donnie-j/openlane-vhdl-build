#!/bin/sh

: ${PREFIX:=/opt/toolflows}
export PREFIX

echo making install dir $PREFIX

# mkdir $PREFIX

echo clone all the things...
mkdir src ; cd src

git clone https://github.com/YosysHQ/icestorm.git &&
git clone --recursive https://github.com/YosysHQ/yosys.git &&
git clone https://github.com/YosysHQ/nextpnr.git &&

git clone https://github.com/ghdl/ghdl.git &&
git clone https://github.com/ghdl/ghdl-yosys-plugin.git &&

cd .. || exit 1

echo clone done

echo making build area

mkdir build; cd build

echo build icestorm

git clone ../src/icestorm &&
cd icestorm &&

patch -p1 <<EOF &&
--- a/config.mk
+++ b/config.mk
@@ -1,4 +1,4 @@
-PREFIX ?= /usr/local
+PREFIX ?= $PREFIX
 DEBUG ?= 0
 ICEPROG ?= 1
 PROGRAM_PREFIX ?=
EOF

make -j12 &&
make install &&

cd .. || exit 1

echo build yosys

git clone --recursive ../src/yosys &&
cd yosys &&

echo checking out v0.52 &&
git checkout --recurse-submodules v0.52 &&

patch -p1 << EOF &&
diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -53,7 +53,7 @@ SANITIZER =
 PROGRAM_PREFIX :=

 OS := \$(shell uname -s)
-PREFIX ?= /usr/local
+PREFIX ?= $PREFIX
 INSTALL_SUDO :=

 ifneq (\$(wildcard Makefile.conf),)
EOF

make config-gcc
make -j12 &&
make install &&

cd .. || exit 1

echo build nextpnr

echo checking out nextpnr-0.8
(cd ../src/nextpnr ; git checkout --recurse-submodules nextpnr-0.8)

mkdir nextpnr &&
cd nextpnr &&
mkdir ../../src/nextpnr/tests/gui &&
touch ../../src/nextpnr/tests/gui/CMakeLists.txt &&

cmake ../../src/nextpnr -DARCH="ice40" -DCMAKE_INSTALL_PREFIX=$PREFIX -DICESTORM_INSTALL_PREFIX=$PREFIX -DBUILD_GUI=OFF -DBUILD_PYTHON=OFF -DSTATIC_BUILD=ON &&
make -j12 &&
make install &&

cd .. || exit 1

echo build ghdl

git clone ../src/ghdl &&
cd ghdl &&

echo checking out v5.0.1 &&
git checkout --recurse-submodules v5.0.1 &&

# On MacOS, gnat lives in /opt
export PATH=/opt/gnat/bin:$PATH &&
#./configure --prefix=$PREFIX                    # for mcode
LDFLAGS="-L/opt/gcc-13.2.0-aarch64//lib/gcc/aarch64-apple-darwin21/13.2.0 -lgcc" PATH=$PATH:/opt/homebrew/Cellar/llvm/19.1.1/bin ./configure --with-llvm-config --prefix=$PREFIX  # for llvm backend

PATH=$PATH:/opt/homebrew/Cellar/llvm/19.1.1/bin make -j12 &&
make install &&

cd .. || exit 1

echo build ghdl-yosys-plugin

git clone ../src/ghdl-yosys-plugin &&
cd ghdl-yosys-plugin &&
git checkout --recurse-submodules 8c29f2cc7cc3b8c979acd02f543d25f321b55c30 &&

export PATH=$PREFIX/bin:$PATH &&
make &&
make install &&

cd .. || exit 1

cd ..
echo Done.
