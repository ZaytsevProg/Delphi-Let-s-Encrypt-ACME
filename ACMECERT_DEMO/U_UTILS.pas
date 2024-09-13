unit U_UTILS;

interface

uses System.SysUtils, System.Variants, System.Classes, IniFiles, FileCtrl, System.NetEncoding;

function Base64UrlEncode(const ADecodedBytes: TBytes): String;
function Base64UrlDecode(const AEncodedString: String): TBytes;
function SelectDir(Caption :String):String;
function SelectFile(Caption :String):String;
function LoadCert64(Cert :String):TBytes;
function GetCertDir():String;
procedure SaveCert(Cert64, CertName :String);

Procedure ReadParams;
Procedure WriteParams;

implementation

uses Main;

function Base64UrlEncode(const ADecodedBytes: TBytes): String;
var
  S: String;
begin
  S := TNetEncoding.Base64.EncodeBytesToString(ADecodedBytes);
  S := S.Replace(#13#10, '', [rfReplaceAll])
    .Replace(#13, '', [rfReplaceAll])
    .Replace(#10, '', [rfReplaceAll])
    .TrimRight(['='])
    .Replace('+', '-', [rfReplaceAll])
    .Replace('/', '_', [rfReplaceAll]);
  Result := S;
end;


function Base64UrlDecode(const AEncodedString: String): TBytes;
var
  S: String;
begin
  S := AEncodedString;
  S := S + StringOfChar('=', (4 - Length(AEncodedString) mod 4) mod 4);
  S := S.Replace('-', '+', [rfReplaceAll])
    .Replace('_', '/', [rfReplaceAll]);
  Result := TNetEncoding.Base64.DecodeStringToBytes(S);
end;


function SelectDir(Caption :String):String;
var
  Dir :String;
begin
SelectDirectory(Caption, '', Dir, [sdNewUI, sdShowEdit]);
if Length(Dir) = 0 then Exit;

Result:=Dir +'\';
end;

function SelectFile(Caption :String):String;
var
  Dir :String;
begin
SelectDirectory(Caption, '', Dir, [sdNewUI, sdShowEdit, sdShowFiles, sdValidateDir]);
if Length(Dir) = 0 then Exit;
Result:=Dir;
end;


function LoadCert64(Cert :String):TBytes;
var
BS_Cert: TBytesStream;
begin
BS_Cert:=TBytesStream.Create(nil);
BS_Cert.LoadFromFile(Cert);
SetLength(Result, BS_Cert.Size);
BS_Cert.Read(Result, Length(Result));
FreeAndNil(BS_Cert);
end;

function GetCertDir():String;
var
CERT_DIR :String;
begin
CERT_DIR:=ExtractFilePath(ParamStr(0)) +'CERT\';
if not DirectoryExists(CERT_DIR) then createdir(CERT_DIR);
Result:=CERT_DIR;
end;

procedure SaveCert(Cert64, CertName :String);
var
BS_Cert: TBytesStream;
begin
BS_Cert:=TBytesStream.Create(Base64UrlDecode(Cert64));
BS_Cert.SaveToFile(CertName);
FreeAndNil(BS_Cert);
end;


Procedure ReadParams;
Var
IniFile: TIniFile;
begin
IniFile:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'ACMECERT_DEMO.ini');
FMain.E_Domain.Text:=            IniFile.ReadString('LE', 'Domain',             FMain.E_Domain.Text);
FMain.E_Mail.Text:=              IniFile.ReadString('LE', 'E_Mail',             FMain.E_Mail.Text);
FMain.E_Challenge_Dir.Text:=     IniFile.ReadString('LE', 'Challenge_Dir',      FMain.E_Challenge_Dir.Text);
FMain.CB_WWW.Checked :=          IniFile.ReadBool('LE',' WWW',                  FMain.CB_WWW.Checked);
FMain.CB_New_Account.Checked :=  IniFile.ReadBool('LE',' Create_New_Account',   FMain.CB_New_Account.Checked);
FMain.E_Account_ID.Text:=        IniFile.ReadString('LE', 'Account_ID',         FMain.E_Account_ID.Text);
FMain.E_AccountPrivateKey.Text:= IniFile.ReadString('LE', 'AccountPrivateKey',  FMain.E_AccountPrivateKey.Text);
IniFile.Free;
end;

Procedure WriteParams;
Var
IniFile: TIniFile;
begin
IniFile:=TiniFile.Create(ExtractFilePath(ParamStr(0))+'ACMECERT_DEMO.ini');
IniFile.WriteString('LE', 'Domain',            FMain.E_Domain.Text);
IniFile.WriteString('LE', 'E_Mail',            FMain.E_Mail.Text);
IniFile.WriteString('LE', 'Challenge_Dir',     FMain.E_Challenge_Dir.Text);
IniFile.WriteBool('LE',' WWW',                 FMain.CB_WWW.Checked);
IniFile.WriteBool('LE',' Create_New_Account',  FMain.CB_New_Account.Checked);
IniFile.WriteString('LE', 'Account_ID',        FMain.E_Account_ID.Text);
IniFile.WriteString('LE', 'AccountPrivateKey', FMain.E_AccountPrivateKey.Text);
IniFile.Free;
end;



end.