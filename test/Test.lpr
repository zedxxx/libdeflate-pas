program Test;

{$MODE DELPHI}

uses
  Classes,
  consoletestrunner,
  u_TestLibDeflate in 'u_TestLibDeflate.pas',
  libdeflate in '..\libdeflate.pas';

var
  Application: TTestRunner;
begin
  DefaultFormat := fPlain;
  DefaultRunAllTests := True;
  
  Application := TTestRunner.Create(nil);
  try
    Application.Initialize;
    Application.Run;
  finally
    Application.Free;
  end;

  Writeln('Press ENTER to exit...');
  Readln;
end.

