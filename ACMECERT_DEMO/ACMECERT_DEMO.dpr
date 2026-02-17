program ACMECERT_DEMO;

uses
  Vcl.Forms,
  U_ACMECERT in 'U_ACMECERT.pas',
  Main in 'Main.pas' {FMain},
  U_Add_Billing in 'U_Add_Billing.pas' {F_Add_Billing};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TF_Add_Billing, F_Add_Billing);
  Application.Run;
end.
