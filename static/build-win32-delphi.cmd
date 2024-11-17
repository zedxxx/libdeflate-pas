@echo off

cd libdeflate

git clean -d -x --force
git reset --hard v1.22

cd lib

set CFLAGS=-O2 -m32 -std=c99 -fno-pic -fno-stack-protector -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -fvisibility=hidden -Wall -Wundef

set SRC=adler32.c crc32.c utils.c deflate_compress.c deflate_decompress.c zlib_decompress.c zlib_compress.c gzip_decompress.c gzip_compress.c x86\cpu_features.c

bcc32x %CFLAGS% -D_WIN32 -D_ANSI_SOURCE -D__GNUC__ -I.. -c %SRC%

move *.obj ..\..\libdeflate-delphi\win32\

pause
