unit u_TestLibDeflate;

interface

uses
  Classes,
  SysUtils,
  {$IFDEF FPC}
  fpcunit,
  testregistry;
  {$ELSE}
  TestFramework;
  {$ENDIF}

type
  TTestLibDeflate= class(TTestCase)
  published
    procedure TestCompression;
    procedure TestDecompression;

    procedure BenchDecompression;
  end;

implementation

uses
  libdeflate;

const
  CTestData: AnsiString = 'Test data for libdeflate';

  CTestDataZlib9: array[0..31] of Byte = (
    $78, $DA, $0B, $49, $2D, $2E, $51, $48, $49, $2C, $49, $54, $48, $CB, $2F, $52,
    $C8, $C9, $4C, $4A, $49, $4D, $CB, $49, $2C, $49, $05, $00, $6C, $F3, $08, $EE
  );

procedure TTestLibDeflate.TestCompression;
var
  P: Pointer;
  VSizeAvail: size_t;
  VCompressedSize: size_t;
  VZlib: libdeflate_compressor;
begin
  VZlib := libdeflate_alloc_compressor(9);
  Check(VZlib <> nil);
  try
    VSizeAvail := Length(CTestData) * 2;
    P := GetMemory(VSizeAvail);
    try
      VCompressedSize := libdeflate_zlib_compress(
        VZlib,
        @CTestData[1],
        Length(CTestData),
        P,
        VSizeAvail
      );

      Check(VCompressedSize > 0);
      Check(VCompressedSize = size_t(Length(CTestDataZlib9)));
      Check(CompareMem(P, @CTestDataZlib9[0], VCompressedSize));
    finally
      FreeMemory(P);
    end;
  finally
    libdeflate_free_compressor(VZlib);
  end;
end;

procedure TTestLibDeflate.TestDecompression;
var
  VSizeAvail: size_t;
  VResult: libdeflate_result;
  VZlib: libdeflate_decompressor;
  VDecompressed: AnsiString;
begin
  VZlib := libdeflate_alloc_decompressor;
  Check(VZlib <> nil);
  try
    VSizeAvail := Length(CTestData);
    SetLength(VDecompressed, VSizeAvail);

    VResult := libdeflate_zlib_decompress(
      VZlib,
      @CTestDataZlib9[0],
      Length(CTestDataZlib9),
      @VDecompressed[1],
      VSizeAvail
    );

    Check(VResult = LIBDEFLATE_SUCCESS);
    Check(VDecompressed = CTestData);
  finally
    libdeflate_free_decompressor(VZlib);
  end;
end;

procedure TTestLibDeflate.BenchDecompression;
var
  I: Integer;
  P: Pointer;
  VActual: size_t;
  VIn, VOut: TMemoryStream;
  VZlib: libdeflate_decompressor;
  VResult: libdeflate_result;
begin
  VZlib := libdeflate_alloc_decompressor;
  Check(VZlib <> nil);
  try
    VIn := TMemoryStream.Create;
    VOut := TMemoryStream.Create;
    try
      VIn.LoadFromFile('..\test\data\zlib_decompress_bench_in');
      VOut.LoadFromFile('..\test\data\zlib_decompress_bench_out');

      P := GetMemory(VOut.Size);
      try
        // Step 1: Test
        VResult := libdeflate_zlib_decompress(
          VZlib,
          VIn.Memory,
          VIn.Size,
          P,
          VOut.Size,
          @VActual
        );

        Check(VResult = LIBDEFLATE_SUCCESS);
        Check(CompareMem(P, VOut.Memory, VOut.Size));

        // Step 2: Bench
        for I := 0 to 3000 do begin
          VResult := libdeflate_zlib_decompress(
            VZlib,
            VIn.Memory,
            VIn.Size,
            P,
            VOut.Size
          );
          Check(VResult = LIBDEFLATE_SUCCESS);
        end;
      finally
        FreeMemory(P);
      end;
    finally
      VOut.Free;
      VIn.Free;
    end;
  finally
    libdeflate_free_decompressor(VZlib);
  end;
end;

initialization
  RegisterTest(TTestLibDeflate{$IFNDEF FPC}.Suite{$ENDIF});

end.

