#!/usr/bin/bash -ex

rev=v1.22

GCC=i686-w64-mingw32-gcc

if [ ! -d "libdeflate" ]; then
    git clone https://github.com/ebiggers/libdeflate
fi

cd libdeflate

git clean -d -x --force
git reset --hard $rev

sed -i "s/__stdcall/__cdecl/" libdeflate.h

cd lib

$GCC -I.. -O2 -m32 -std=c99 -static \
    -fno-pic -fno-stack-protector -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -fvisibility=hidden \
    -Wall -Wundef \
    -D_WIN32 -D_ANSI_SOURCE  \
    -c x86/cpu_features.c adler32.c crc32.c utils.c \
    deflate_decompress.c deflate_compress.c \
    zlib_decompress.c zlib_compress.c \
    gzip_decompress.c gzip_compress.c

# strip -d -x "*.o"

ar rcs libdeflate-win32.a cpu_features.o adler32.o crc32.o utils.o deflate_decompress.o deflate_compress.o zlib_decompress.o zlib_compress.o gzip_decompress.o gzip_compress.o

mv -f -v libdeflate-win32.a ../../
