program ACMECERT_DEMO;

uses
  Vcl.Forms,
  U_ACMECERT in 'U_ACMECERT.pas',
  Main in 'Main.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
