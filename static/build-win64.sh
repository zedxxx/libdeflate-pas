#!/usr/bin/bash -ex

GCC=gcc

cd ../.libdeflate

git clean -d -x --force
git reset --hard v1.8

cd lib

$GCC -I.. -O2 -m64 -std=c99 -static \
    -fno-pic -fno-stack-protector -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -fvisibility=hidden \
    -Wall -Wundef \
    -D_WIN64 -D_ANSI_SOURCE  \
    -c x86/cpu_features.c adler32.c crc32.c utils.c \
    deflate_decompress.c deflate_compress.c \
    zlib_decompress.c zlib_compress.c \
    gzip_decompress.c gzip_compress.c

strip -d -x "*.o"

ar rcs libdeflate-win64.a cpu_features.o adler32.o crc32.o utils.o deflate_decompress.o deflate_compress.o zlib_decompress.o zlib_compress.o gzip_decompress.o gzip_compress.o

mv libdeflate-win64.a ../../static/
