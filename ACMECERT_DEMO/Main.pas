unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, IniFiles, FileCtrl,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TFMain = class(TForm)
    PC_Main: TPageControl;
    TAB_GenerateLE: TTabSheet;
    TAB_ConvertCert: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    E_Domain: TEdit;
    E_Mail: TEdit;
    B_Execute_GenerateLE: TButton;
    Label3: TLabel;
    E_Challenge_Dir: TEdit;
    SB_Open_Challenge_Dir: TSpeedButton;
    CB_WWW: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    E_Certificate: TEdit;
    E_PrivateKey: TEdit;
    E_CERT_CA: TEdit;
    E_Password: TEdit;
    Label8: TLabel;
    E_Friendly_Name: TEdit;
    Label9: TLabel;
    E_Save_PKCS12: TEdit;
    B_Execute_Convert: TButton;
    SB_Open_Cert: TSpeedButton;
    SB_Open_PrivateKey: TSpeedButton;
    SB_Open_CA: TSpeedButton;
    SB_Open_PKCS12: TSpeedButton;
    CB_New_Account: TCheckBox;
    E_Account_URL: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    E_AccountPrivateKey: TEdit;
    SB_Open_AccountPrivateKey_Dir: TSpeedButton;
    L_Before: TLabel;
    L_After: TLabel;
    procedure SB_Open_Challenge_DirClick(Sender: TObject);
    procedure B_Execute_GenerateLEClick(Sender: TObject);
    procedure SB_Open_CertClick(Sender: TObject);
    procedure SB_Open_PrivateKeyClick(Sender: TObject);
    procedure SB_Open_CAClick(Sender: TObject);
    procedure SB_Open_PKCS12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SB_Open_AccountPrivateKey_DirClick(Sender: TObject);
    procedure B_Execute_ConvertClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
      Procedure ReadParams;
      Procedure WriteParams;
      function SelectFile(const Title, Filter :String):String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses U_ACMECERT;


procedure TFMain.B_Execute_ConvertClick(Sender: TObject);
var
PEM_To_PKCS12 :PPEM_To_PKCS12;
PKCS12   :TBuffer;
ErrorBuf :PChar;
begin
TRY
  TRY
    if Length(E_Certificate.Text) = 0 then begin ShowMessage('Certificate must be filled.'); Exit; end;
    if Length(E_PrivateKey.Text)  = 0 then begin ShowMessage('Private Key must be filled.'); Exit; end;

    New(PEM_To_PKCS12);
    LoadFile(E_Certificate.Text, PEM_To_PKCS12.CERT);
    LoadFile(E_PrivateKey.Text,  PEM_To_PKCS12.PKEY);
    LoadFile(E_CERT_CA.Text,     PEM_To_PKCS12.CA);
    PEM_To_PKCS12.Password       :=StringToPAnsiChar(E_Password.Text);
    PEM_To_PKCS12.Friendly_Name  :=StringToPAnsiChar(E_Friendly_Name.Text);

    if not EXECUTE_CONVERT_PEM_To_PKCS12(PEM_To_PKCS12, PKCS12, ErrorBuf) then
     Messagedlg(StrPas(ErrorBuf), mterror, [mbNo],0)
    Else
     SaveFile(E_Save_PKCS12.Text +'CERT.P12', PKCS12.Buf, PKCS12.Size);


  FINALLY
   TBuffer_Free(PKCS12);
   Buffer_Free(PEM_To_PKCS12.CERT);
   Buffer_Free(PEM_To_PKCS12.PKEY);
   Buffer_Free(PEM_To_PKCS12.CA);
   Dispose(PEM_To_PKCS12);
  END;

except on e:exception do
 Messagedlg(e.Message, mterror, [mbNo],0);
end;

end;


procedure TFMain.B_Execute_GenerateLEClick(Sender: TObject);
var
CREATE_ACMECERT :PCREATE_ACMECERT;
ACCOUNT  :TACCOUNT;
ACMECERT :TACMECERT;
ErrorBuf :PChar;
begin
TRY
  TRY
    if Length(E_Domain.Text)        = 0 then begin ShowMessage('Domain must be filled.'); Exit; end;
    if Length(E_Mail.Text)          = 0 then begin ShowMessage('Account E-Mail must be filled.'); Exit; end;
    if Length(E_Challenge_Dir.Text) = 0 then begin ShowMessage('Challenge Directory must be filled.'); Exit; end;

    if not CB_New_Account.Checked then begin
    if Length(E_Account_URL.Text)       = 0 then begin ShowMessage('Account URL must be filled.'); Exit; end;
    if Length(E_AccountPrivateKey.Text) = 0 then begin ShowMessage('AccountPrivateKey must be filled.'); Exit; end;
    end;

    New(CREATE_ACMECERT);
    ZeroMemory(@ACCOUNT,  SizeOf(ACCOUNT));
    ZeroMemory(@ACMECERT, SizeOf(ACMECERT));

    CREATE_ACMECERT.LE_URL        :=StringToPAnsiChar('https://acme-v02.api.letsencrypt.org');
    CREATE_ACMECERT.Domain        :=StringToPAnsiChar(E_Domain.Text);
    CREATE_ACMECERT.E_Mail        :=StringToPAnsiChar(E_Mail.Text);
    CREATE_ACMECERT.Challenge_Dir :=StringToPAnsiChar(E_Challenge_Dir.Text);
    CREATE_ACMECERT.WWW           :=CB_WWW.Checked;
    ACMECERT.P12_ADD_CA           :=False;


    if not CB_New_Account.Checked then begin
     ACCOUNT.New_Account:=False;
     ACCOUNT.Account_URL:=StringToPAnsiChar(E_Account_URL.Text);
     LoadFile(E_AccountPrivateKey.Text, ACCOUNT.AccountPrivateKey);
    end
    Else begin
     ACCOUNT.New_Account:=True;
     ACCOUNT.Account_URL:=nil;
     ACCOUNT.AccountPrivateKey.Size:=0;
     ACCOUNT.AccountPrivateKey.Buf:=nil;
    end;


    if not EXECUTE_CREATE_ACMECERT(CREATE_ACMECERT, @ACCOUNT, @ACMECERT, ErrorBuf) then
     Messagedlg(StrPas(ErrorBuf), mterror, [mbNo],0)
    Else begin
      if CB_New_Account.Checked then E_Account_URL.Text:=PAnsiChar(ACCOUNT.Account_URL);
      L_Before.Caption:='DT_BEFORE: ' +FormatDateTime('dd.mm.yyyy hh:mm:ss', UDT_ToDateTime(ACMECERT.DT_BEFORE));
      L_After.Caption :='DT_AFTER: '  +FormatDateTime('dd.mm.yyyy hh:mm:ss', UDT_ToDateTime(ACMECERT.DT_AFTER));

       {
       PAnsiChar(ACMECERT.Domain)
       PAnsiChar(ACMECERT.E_Mail)
       PAnsiChar(ACMECERT.SUBJECT)
       PAnsiChar(ACMECERT.ISSUER)
       PAnsiChar(ACMECERT.SN)
       PAnsiChar(ACMECERT.URL_Certificate)
       }

      SaveFile(GetCertDir +'AccountPrivateKey.pem', ACCOUNT.AccountPrivateKey.Buf, ACCOUNT.AccountPrivateKey.Size);
      SaveFile(GetCertDir +'PrivateKey.pem', ACMECERT.PrivateKey.Buf, ACMECERT.PrivateKey.Size);
      SaveFile(GetCertDir +'CERT.pem', ACMECERT.CERT.Buf, ACMECERT.CERT.Size);
      SaveFile(GetCertDir +'CA.pem', ACMECERT.CA.Buf, ACMECERT.CA.Size);
      SaveFile(GetCertDir +'OTHER.pem', ACMECERT.OTHER.Buf, ACMECERT.OTHER.Size);
      SaveFile(GetCertDir +'CERT.P12', ACMECERT.CERT_P12.Buf, ACMECERT.CERT_P12.Size);

    end;


  FINALLY
   ACCOUNT.Account_URL:=nil;
   if not CB_New_Account.Checked then Buffer_Free(ACCOUNT.AccountPrivateKey);
   if     CB_New_Account.Checked then TBuffer_Free(ACCOUNT.AccountPrivateKey);
   TBuffer_Free(ACMECERT.PrivateKey);
   TBuffer_Free(ACMECERT.CERT);
   TBuffer_Free(ACMECERT.CA);
   TBuffer_Free(ACMECERT.OTHER);
   TBuffer_Free(ACMECERT.CERT_P12);

   Dispose(CREATE_ACMECERT);
  END;

except on e:exception do
 Messagedlg(e.Message, mterror, [mbNo],0);
end;

end;



procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
WriteParams;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
PC_Main.ActivePageIndex:=0;
ReadParams;
end;

procedure TFMain.SB_Open_CAClick(Sender: TObject);
begin
E_CERT_CA.Text:=SelectFile('CA Certificate (pem)', 'Certificate files (pem)|*.pem|All files|*.*');
end;

procedure TFMain.SB_Open_CertClick(Sender: TObject);
begin
E_Certificate.Text:=SelectFile('Certificate (pem)', 'Certificate files (pem)|*.pem|All files|*.*');
end;

procedure TFMain.SB_Open_Challenge_DirClick(Sender: TObject);
begin
E_Challenge_Dir.Text:=SelectDir('Challenge Directory');
end;

procedure TFMain.SB_Open_PKCS12Click(Sender: TObject);
begin
E_Save_PKCS12.Text:=SelectDir('Save PKCS12 Certificate to Directory');
end;

procedure TFMain.SB_Open_PrivateKeyClick(Sender: TObject);
begin
E_PrivateKey.Text:=SelectFile('Private Key (pem)', 'Certificate files (pem)|*.pem|All files|*.*');
end;

procedure TFMain.SB_Open_AccountPrivateKey_DirClick(Sender: TObject);
begin
E_AccountPrivateKey.Text:=SelectFile('AccountPrivateKey (pem)', 'Certificate files (pem)|*.pem|All files|*.*');
end;


Procedure TFMain.ReadParams;
Var
IniFile: TIniFile;
begin
Try
  IniFile:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'ACMECERT_DEMO.ini');
  FMain.E_Domain.Text:=            IniFile.ReadString('LE', 'Domain',             FMain.E_Domain.Text);
  FMain.E_Mail.Text:=              IniFile.ReadString('LE', 'E_Mail',             FMain.E_Mail.Text);
  FMain.E_Challenge_Dir.Text:=     IniFile.ReadString('LE', 'Challenge_Dir',      FMain.E_Challenge_Dir.Text);
  FMain.CB_WWW.Checked :=          IniFile.ReadBool('LE',' WWW',                  FMain.CB_WWW.Checked);
  FMain.CB_New_Account.Checked :=  IniFile.ReadBool('LE',' Create_New_Account',   FMain.CB_New_Account.Checked);
  FMain.E_Account_URL.Text:=       IniFile.ReadString('LE', 'Account_URL',        FMain.E_Account_URL.Text);
  FMain.E_AccountPrivateKey.Text:= IniFile.ReadString('LE', 'AccountPrivateKey',  FMain.E_AccountPrivateKey.Text);

FINALLY
  if Assigned(IniFile) then IniFile.Free;
End;

end;

Procedure TFMain.WriteParams;
Var
IniFile: TIniFile;
begin
Try
  IniFile:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'ACMECERT_DEMO.ini');
  IniFile.WriteString('LE', 'Domain',            FMain.E_Domain.Text);
  IniFile.WriteString('LE', 'E_Mail',            FMain.E_Mail.Text);
  IniFile.WriteString('LE', 'Challenge_Dir',     FMain.E_Challenge_Dir.Text);
  IniFile.WriteBool('LE',' WWW',                 FMain.CB_WWW.Checked);
  IniFile.WriteBool('LE',' Create_New_Account',  FMain.CB_New_Account.Checked);
  IniFile.WriteString('LE', 'Account_URL',       FMain.E_Account_URL.Text);
  IniFile.WriteString('LE', 'AccountPrivateKey', FMain.E_AccountPrivateKey.Text);

FINALLY
  if Assigned(IniFile) then IniFile.Free;
End;

end;

function TFMain.SelectFile(Const Title, Filter :String):String;
var
Dialog: TOpenDialog;
begin
Result:='';
Try
  Try
    Dialog:=TOpenDialog.Create(nil);
    Dialog.FileName:='';
    Dialog.Title:=Title;
    Dialog.Filter:= Filter;
    Dialog.InitialDir:=ExtractFilePath(ParamStr(0));
    if Dialog.Execute then
     Result:= Dialog.FileName;

  Finally
   if Assigned(Dialog) then Dialog.Free;
  End;

except on E:Exception do
 Messagedlg(e.Message, mterror, [mbNo],0);
End;

end;


end.
