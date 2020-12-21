#!/bin/bash

set -ex

mkdir -p build
BUILD="$PWD/build"

curl -OL https://ftp.postgresql.org/pub/source/v13.1/postgresql-13.1.tar.bz2
tar xjf postgresql-13.1.tar.bz2

cd postgresql-13.1
./configure --prefix="$BUILD"
make submake-libpq
make -C src/include install
make -C src/interfaces/libpq install
cd ..

git clone https://github.com/jtv/libpqxx.git

cd libpqxx
git checkout b25851630ee28cab0f395cab6dde1397c1749e96
CXX=/usr/bin/clang++ ./configure --with-postgres-include="$BUILD/include" --with-postgres-lib="$BUILD/lib" \
    --prefix="$BUILD" 2>&1 | tee ../pqxx-configure.log
make install 2>&1 | tee ../pqxx-compile.log
cd ..

/usr/bin/clang++ \
  -Wall --std=c++17 \
  -o testprogram testprogram.cc \
  -fvisibility=hidden -fvisibility-inlines-hidden \
  -I"$BUILD"/include -L"$BUILD"/lib -lpq -lpqxx 2>&1 | \
  tee compile.log
