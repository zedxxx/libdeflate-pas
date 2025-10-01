@echo off

if not exist "libdeflate" (
  git clone https://github.com/ebiggers/libdeflate
)

if not exist "libdeflate" (
  exit
)

cd libdeflate

git clean -d -x --force
git fetch
git reset --hard v1.24

cd lib

set CFLAGS=-O2 -m64 -std=c99 -fno-pic -fno-stack-protector -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -fvisibility=hidden -Wall -Wundef

set SRC=adler32.c crc32.c utils.c deflate_compress.c deflate_decompress.c zlib_decompress.c zlib_compress.c gzip_decompress.c gzip_compress.c x86\cpu_features.c

bcc64x %CFLAGS% -D_WIN64 -D_ANSI_SOURCE -I.. -c %SRC%

move *.o ..\..\libdeflate-delphi\win64\

pause
