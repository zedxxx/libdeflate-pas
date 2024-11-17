program Test;

uses
  Forms,
  {$IFDEF FPC}
  Interfaces,
  {$ELSE}
  TestFramework,
  {$ENDIF}
  GUITestRunner,
  u_TestLibDeflate in 'u_TestLibDeflate.pas',
  libdeflate in '..\libdeflate.pas';

begin
  Application.Initialize;
  {$IFDEF FPC}
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
  {$ELSE}
  GUITestRunner.RunRegisteredTests;
  {$ENDIF}
end.

