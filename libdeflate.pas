unit libdeflate;

// https://github.com/ebiggers/libdeflate

interface

{$ALIGN ON}
{$MINENUMSIZE 4}

{.$define USE_LIBDEFLATE_DLL}

(******************************************************************************)

// Windows developers: note that the calling convention of libdeflate.dll is "cdecl"
// (libdeflate v1.4 through v1.12 used "stdcall" instead)

{$ifdef WIN32}
  {$define USE_CDECL} // comment this line if you use old libdeflate build with "stdcall"

  {$if defined(FPC) and not defined(USE_LIBDEFLATE_DLL)}
    // always build static libs for FPC with "cdecl" fix!
    {$define USE_CDECL}
  {$endif}
{$endif}

{$if defined(USE_CDECL) and not defined(USE_LIBDEFLATE_DLL) and not defined(FPC)}
const
  _PU = '_';
{$else}
const
  _PU = '';
{$endif}

(******************************************************************************)

const
  libdeflate_dll = 'libdeflate.dll';

type
  size_t = {$ifdef WIN32} Cardinal {$else} UInt64 {$endif};
  psize_t = ^size_t;

(* ========================================================================== *)
(*                             Compression                                    *)
(* ========================================================================== *)

type
  libdeflate_compressor = Pointer;

const
  CDefaultCompressionLevel = 6;

(*
 * libdeflate_alloc_compressor() allocates a new compressor that supports
 * DEFLATE, zlib, and gzip compression.  'compression_level' is the compression
 * level on a zlib-like scale but with a higher maximum value (1 = fastest, 6 =
 * medium/default, 9 = slow, 12 = slowest).  The return value is a pointer to
 * the new compressor, or NULL if out of memory.
 *
 * Note: for compression, the sliding window size is defined at compilation time
 * to 32768, the largest size permissible in the DEFLATE format. It cannot be
 * changed at runtime.
 *
 * A single compressor is not safe to use by multiple threads concurrently.
 * However, different threads may use different compressors concurrently.
 *)
function libdeflate_alloc_compressor(
  compression_level: Integer
): libdeflate_compressor; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_alloc_compressor';

(*
 * libdeflate_deflate_compress() performs raw DEFLATE compression on a buffer of
 * data.  The function attempts to compress 'in_nbytes' bytes of data located at
 * 'in' and write the results to 'out', which has space for 'out_nbytes_avail'
 * bytes.  The return value is the compressed size in bytes, or 0 if the data
 * could not be compressed to 'out_nbytes_avail' bytes or fewer.
 *)
function libdeflate_deflate_compress(
  compressor: libdeflate_compressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_deflate_compress';

(*
 * libdeflate_deflate_compress_bound() returns a worst-case upper bound on the
 * number of bytes of compressed data that may be produced by compressing any
 * buffer of length less than or equal to 'in_nbytes' using
 * libdeflate_deflate_compress() with the specified compressor.  Mathematically,
 * this bound will necessarily be a number greater than or equal to 'in_nbytes'.
 * It may be an overestimate of the true upper bound.  The return value is
 * guaranteed to be the same for all invocations with the same compressor and
 * same 'in_nbytes'.
 *
 * As a special case, 'compressor' may be NULL.  This causes the bound to be
 * taken across *any* libdeflate_compressor that could ever be allocated with
 * this build of the library, with any options.
 *
 * Note that this function is not necessary in many applications.  With
 * block-based compression, it is usually preferable to separately store the
 * uncompressed size of each block and to store any blocks that did not compress
 * to less than their original size uncompressed.  In that scenario, there is no
 * need to know the worst-case compressed size, since the maximum number of
 * bytes of compressed data that may be used would always be one less than the
 * input length.  You can just pass a buffer of that size to
 * libdeflate_deflate_compress() and store the data uncompressed if
 * libdeflate_deflate_compress() returns 0, indicating that the compressed data
 * did not fit into the provided output buffer.
 *)
function libdeflate_deflate_compress_bound(
  compressor: libdeflate_compressor;
	in_nbytes: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_deflate_compress_bound';

(*
 * Like libdeflate_deflate_compress(), but stores the data in the zlib wrapper
 * format.
 *)
function libdeflate_zlib_compress(
  compressor: libdeflate_compressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_zlib_compress';

(*
 * Like libdeflate_deflate_compress_bound(), but assumes the data will be
 * compressed with libdeflate_zlib_compress() rather than with
 * libdeflate_deflate_compress().
 *)
function libdeflate_zlib_compress_bound(
  compressor: libdeflate_compressor;
	in_nbytes: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_zlib_compress_bound';

(*
 * Like libdeflate_deflate_compress(), but stores the data in the gzip wrapper
 * format.
 *)
function libdeflate_gzip_compress(
  compressor: libdeflate_compressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_gzip_compress';

(*
 * Like libdeflate_deflate_compress_bound(), but assumes the data will be
 * compressed with libdeflate_gzip_compress() rather than with
 * libdeflate_deflate_compress().
 *)
function libdeflate_gzip_compress_bound(
  compressor: libdeflate_compressor;
	in_nbytes: size_t
): size_t; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_gzip_compress_bound';

(*
 * libdeflate_free_compressor() frees a compressor that was allocated with
 * libdeflate_alloc_compressor().  If a NULL pointer is passed in, no action is
 * taken.
 *)
procedure libdeflate_free_compressor(
  compressor: libdeflate_compressor
); {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_free_compressor';

(* ========================================================================== *)

(*                             Decompression                                  *)
(* ========================================================================== *)
type
  libdeflate_decompressor = Pointer;
(*
 * libdeflate_alloc_decompressor() allocates a new decompressor that can be used
 * for DEFLATE, zlib, and gzip decompression.  The return value is a pointer to
 * the new decompressor, or NULL if out of memory.
 *
 * This function takes no parameters, and the returned decompressor is valid for
 * decompressing data that was compressed at any compression level and with any
 * sliding window size.
 *
 * A single decompressor is not safe to use by multiple threads concurrently.
 * However, different threads may use different decompressors concurrently.
 *)
function libdeflate_alloc_decompressor: libdeflate_decompressor;
{$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_alloc_decompressor';

(*
 * Result of a call to libdeflate_deflate_decompress(),
 * libdeflate_zlib_decompress(), or libdeflate_gzip_decompress().
 *)
type
  libdeflate_result = (
    (* Decompression was successful. *)
    LIBDEFLATE_SUCCESS = 0,
    (* Decompressed failed because the compressed data was invalid, corrupt,
     * or otherwise unsupported.  *)
    LIBDEFLATE_BAD_DATA = 1,
    (* A NULL 'actual_out_nbytes_ret' was provided, but the data would have
     * decompressed to fewer than 'out_nbytes_avail' bytes.  *)
    LIBDEFLATE_SHORT_OUTPUT = 2,
    (* The data would have decompressed to more than 'out_nbytes_avail'
     * bytes.  *)
    LIBDEFLATE_INSUFFICIENT_SPACE = 3
  );
(*
 * libdeflate_deflate_decompress() decompresses the DEFLATE-compressed stream
 * from the buffer 'in' with compressed size up to 'in_nbytes' bytes.  The
 * uncompressed data is written to 'out', a buffer with size 'out_nbytes_avail'
 * bytes.  If decompression succeeds, then 0 (LIBDEFLATE_SUCCESS) is returned.
 * Otherwise, a nonzero result code such as LIBDEFLATE_BAD_DATA is returned.  If
 * a nonzero result code is returned, then the contents of the output buffer are
 * undefined.
 *
 * Decompression stops at the end of the DEFLATE stream (as indicated by the
 * BFINAL flag), even if it is actually shorter than 'in_nbytes' bytes.
 *
 * libdeflate_deflate_decompress() can be used in cases where the actual
 * uncompressed size is known (recommended) or unknown (not recommended):
 *
 *   - If the actual uncompressed size is known, then pass the actual
 *     uncompressed size as 'out_nbytes_avail' and pass NULL for
 *     'actual_out_nbytes_ret'.  This makes libdeflate_deflate_decompress() fail
 *     with LIBDEFLATE_SHORT_OUTPUT if the data decompressed to fewer than the
 *     specified number of bytes.
 *
 *   - If the actual uncompressed size is unknown, then provide a non-NULL
 *     'actual_out_nbytes_ret' and provide a buffer with some size
 *     'out_nbytes_avail' that you think is large enough to hold all the
 *     uncompressed data.  In this case, if the data decompresses to less than
 *     or equal to 'out_nbytes_avail' bytes, then
 *     libdeflate_deflate_decompress() will write the actual uncompressed size
 *     to *actual_out_nbytes_ret and return 0 (LIBDEFLATE_SUCCESS).  Otherwise,
 *     it will return LIBDEFLATE_INSUFFICIENT_SPACE if the provided buffer was
 *     not large enough but no other problems were encountered, or another
 *     nonzero result code if decompression failed for another reason.
 *)
function libdeflate_deflate_decompress(
  decompressor: libdeflate_decompressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t;
  actual_out_nbytes_ret: psize_t = nil
): libdeflate_result; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_deflate_decompress';

(*
 * Like libdeflate_deflate_decompress(), but assumes the zlib wrapper format
 * instead of raw DEFLATE.
 *)
function libdeflate_zlib_decompress(
  decompressor: libdeflate_decompressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t;
  actual_out_nbytes_ret: psize_t = nil
): libdeflate_result; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_zlib_decompress';

(*
 * Like libdeflate_deflate_decompress(), but assumes the gzip wrapper format
 * instead of raw DEFLATE.
 *
 * If multiple gzip-compressed members are concatenated, then only the first
 * will be decompressed.  Use libdeflate_gzip_decompress_ex() if you need
 * multi-member support.
 *)
function libdeflate_gzip_decompress(
  decompressor: libdeflate_decompressor;
  const in_: Pointer;
  in_nbytes: size_t;
  out_: Pointer;
  out_nbytes_avail: size_t;
  actual_out_nbytes_ret: psize_t = nil
): libdeflate_result; {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_gzip_decompress';

(*
 * libdeflate_free_decompressor() frees a decompressor that was allocated with
 * libdeflate_alloc_decompressor().  If a NULL pointer is passed in, no action
 * is taken.
 *)
procedure libdeflate_free_decompressor(
  decompressor: libdeflate_decompressor
); {$ifdef WIN32} {$ifdef USE_CDECL} cdecl {$else} stdcall {$endif}; {$endif}
external {$ifdef USE_LIBDEFLATE_DLL} libdeflate_dll {$endif} name _PU + 'libdeflate_free_decompressor';

implementation

{$ifndef USE_LIBDEFLATE_DLL}

{$ifdef FPC}
  {$ifdef WIN32}
    {$linklib static/libdeflate-win32.a}
  {$else}
    {$linklib static/libdeflate-win64.a}
  {$endif}
{$else}
  {$ifdef WIN32}
    {$L static/libdeflate-delphi/win32/gzip_compress.obj}
    {$L static/libdeflate-delphi/win32/zlib_compress.obj}
    {$L static/libdeflate-delphi/win32/deflate_compress.obj}
    {$L static/libdeflate-delphi/win32/gzip_decompress.obj}
    {$L static/libdeflate-delphi/win32/zlib_decompress.obj}
    {$L static/libdeflate-delphi/win32/deflate_decompress.obj}
    {$L static/libdeflate-delphi/win32/crc32.obj}
    {$L static/libdeflate-delphi/win32/adler32.obj}
    {$L static/libdeflate-delphi/win32/utils.obj}
    {$L static/libdeflate-delphi/win32/cpu_features.obj}
  {$else}
    {$L static/libdeflate-delphi/win64/gzip_compress.o}
    {$L static/libdeflate-delphi/win64/zlib_compress.o}
    {$L static/libdeflate-delphi/win64/deflate_compress.o}
    {$L static/libdeflate-delphi/win64/gzip_decompress.o}
    {$L static/libdeflate-delphi/win64/zlib_decompress.o}
    {$L static/libdeflate-delphi/win64/deflate_decompress.o}
    {$L static/libdeflate-delphi/win64/crc32.o}
    {$L static/libdeflate-delphi/win64/adler32.o}
    {$L static/libdeflate-delphi/win64/utils.o}
    {$L static/libdeflate-delphi/win64/cpu_features.o}
  {$endif}
{$endif}

//{$ifndef FPC}
//uses
//  System.Win.Crtl;
//{$endif}

{$if defined(WIN32) and defined(FPC)}
const
  PU = '_';
{$else}
const
  PU = '';
{$endif}

{$ifdef WIN32}
function _malloc(ASize: size_t): Pointer; cdecl;
{$else}
function malloc(ASize: size_t): Pointer;
{$endif}
{$ifdef FPC} public name PU + 'malloc'; {$endif}
begin
  GetMem(Result, ASize);
end;

{$ifdef WIN32}
procedure _free(P: Pointer); cdecl;
{$else}
procedure free(P: Pointer);
{$endif}
{$ifdef FPC} public name PU + 'free'; {$endif}
begin
  FreeMem(P);
end;

{$ifdef WIN32}
function _memset(P: Pointer; B: Integer; ACount: size_t): Pointer; cdecl;
{$else}
function memset(P: Pointer; B: Integer; ACount: size_t): Pointer;
{$endif}
{$ifdef FPC} public name PU + 'memset'; {$endif}
begin
  FillChar(P^, ACount, B);
  Result := P;
end;

{$ifdef WIN32}
function _memcpy(ADest, ASource: Pointer; ACount: size_t): Pointer; cdecl;
{$else}
function memcpy(ADest, ASource: Pointer; ACount: size_t): Pointer;
{$endif}
{$ifdef FPC} public name PU + 'memcpy'; {$endif}
begin
  System.Move(PByte(ASource)^, PByte(ADest)^, ACount);
  Result := ADest;
end;

{$ifdef WIN32}
function _memmove(ADest, ASource: Pointer; ACount: size_t): Pointer; cdecl;
{$else}
function memmove(ADest, ASource: Pointer; ACount: size_t): Pointer;
{$endif}
{$ifdef FPC} public name PU + 'memmove'; {$endif}
begin
  System.Move(PByte(ASource)^, PByte(ADest)^, ACount);
  Result := ADest;
end;

{$ifdef WIN32}
function _memcmp(ADest, ASource: Pointer; ACount: size_t): Integer; cdecl;
{$else}
function memcmp(ADest, ASource: Pointer; ACount: size_t): Integer;
{$endif}
{$ifdef FPC} public name PU + 'memcmp'; {$endif}
begin
  while ACount > 0 do begin
    Result := PByte(ADest)^ - PByte(ASource)^;
    if Result <> 0 then begin
      Exit;
    end;
    Dec(ACount);
    Inc(PByte(ADest));
    Inc(PByte(ASource));
  end;
  Result := 0;
end;

{$endif} // USE_LIBDEFLATE_DLL

end.

