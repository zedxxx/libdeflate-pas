program Test;

uses
  Forms,
  TestFramework,
  GUITestRunner,
  u_TestLibDeflate in 'u_TestLibDeflate.pas',
  libdeflate in '..\libdeflate.pas';

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
  RunRegisteredTests;
end.

