program ACMECERT_DEMO;

uses
  Vcl.Forms,
  U_UTILS in 'U_UTILS.pas',
  Main in 'Main.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
