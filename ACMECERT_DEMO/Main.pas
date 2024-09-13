unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.JSON,
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
    E_CA: TEdit;
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
    E_Account_ID: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    E_AccountPrivateKey: TEdit;
    SpeedButton1: TSpeedButton;
    L_Before: TLabel;
    L_After: TLabel;
    procedure SB_Open_Challenge_DirClick(Sender: TObject);
    procedure B_Execute_GenerateLEClick(Sender: TObject);
    procedure SB_Open_CertClick(Sender: TObject);
    procedure SB_Open_PrivateKeyClick(Sender: TObject);
    procedure SB_Open_CAClick(Sender: TObject);
    procedure SB_Open_PKCS12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure B_Execute_ConvertClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function EXECUTE_ACMECLIENT(P_IN_JSON :Pointer; IN_JSON_LEN :Integer;
  out P_OUT_JSON :Pointer; out OUT_JSON_LEN :Integer): Integer; stdcall; external 'ACMECERT.DLL';

  function PEM_To_PKCS12(P_IN_JSON :Pointer; IN_JSON_LEN :Integer;
  out P_OUT_JSON :Pointer; out OUT_JSON_LEN :Integer): Integer; stdcall; external 'ACMECERT.DLL';

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses U_UTILS;


procedure TFMain.B_Execute_ConvertClick(Sender: TObject);
var
BS_JSON: TBytesStream;
In_JSON, Out_JSON: TJSONObject;
P_OUT_JSON :Pointer;
OUT_JSON_LEN :Integer;
Res :Integer;
begin
if Length(E_Certificate.Text) = 0 then begin ShowMessage('Certificate must be filled.'); Exit; end;
if Length(E_PrivateKey.Text) = 0  then begin ShowMessage('Private Key must be filled.'); Exit; end;
//if Length(E_Save_PKCS12.Text) = 0 then begin ShowMessage('Save PKCS12 must be filled.'); Exit; end;

In_JSON:=TJSONObject.Create;
In_JSON.AddPair('CERT',          Base64UrlEncode(LoadCert64(E_Certificate.Text)));
In_JSON.AddPair('PrivateKey',    Base64UrlEncode(LoadCert64(E_PrivateKey.Text)));
if Length(E_CA.Text) > 0 then In_JSON.AddPair('CA', Base64UrlEncode(LoadCert64(E_CA.Text)));
if Length(E_CA.Text) = 0 then In_JSON.AddPair('CA', '');
In_JSON.AddPair('Password',      E_Password.Text);
In_JSON.AddPair('Friendly_Name', E_Friendly_Name.Text);

BS_JSON:=TBytesStream.Create(nil);
BS_JSON.WriteBuffer(BytesOf(In_JSON.ToJSON), Length(In_JSON.ToJSON));
In_JSON.Free;
BS_JSON.Position := 0;
BS_JSON.Seek(0,0);
Res:=PEM_To_PKCS12(BS_JSON.Memory, BS_JSON.Size, P_OUT_JSON, OUT_JSON_LEN);
FreeAndNil(BS_JSON);

if (P_OUT_JSON <> nil) and (OUT_JSON_LEN > 0) then begin
BS_JSON:=TBytesStream.Create(nil);
BS_JSON.WriteBuffer(P_OUT_JSON^, OUT_JSON_LEN);
BS_JSON.Position := 0;
BS_JSON.Seek(0,0);
Out_JSON:=TJSONObject.Create;
Out_JSON.Parse(BS_JSON.Bytes, 0);
BS_JSON.SaveToFile('CERT_JSON.json');
if Res = 0 then begin
//Out_JSON.Values['SUBJECT'].Value;
//Out_JSON.Values['ISSUER'].Value;
if Length(Out_JSON.Values['CERT_P12'].Value) > 0 then
SaveCert(Out_JSON.Values['CERT_P12'].Value, E_Save_PKCS12.Text + Out_JSON.Values['CN'].Value +'.P12');
end
else
ShowMessage(Out_JSON.Values['ERROR'].Value);


Out_JSON.Free;
FreeAndNil(BS_JSON);
end;

//P_OUT_JSON:=nil;
end;




procedure TFMain.B_Execute_GenerateLEClick(Sender: TObject);
var
BS_JSON: TBytesStream;
In_JSON, In_JSON_CHILD, Out_JSON: TJSONObject;
ArrayElement :TJSonValue;
P_OUT_JSON :Pointer;
OUT_JSON_LEN :Integer;
Res :Integer;
begin
if Length(E_Domain.Text) = 0         then begin ShowMessage('Domain must be filled.'); Exit; end;
if Length(E_Mail.Text) = 0           then begin ShowMessage('Account E-Mail must be filled.'); Exit; end;
if Length(E_Challenge_Dir.Text) = 0  then begin ShowMessage('Challenge Directory must be filled.'); Exit; end;

if CB_New_Account.Checked = False then begin
if Length(E_Account_ID.Text) = 0         then begin ShowMessage('Account ID must be filled.'); Exit; end;
if Length(E_AccountPrivateKey.Text) = 0  then begin ShowMessage('AccountPrivateKey must be filled.'); Exit; end;
end;

In_JSON:=TJSONObject.Create;
In_JSON.AddPair('LE_URL',            'https://acme-v02.api.letsencrypt.org');
In_JSON.AddPair('Domain',            E_Domain.Text);
In_JSON.AddPair('E_Mail',            E_Mail.Text);
In_JSON.AddPair('Challenge_Dir',     E_Challenge_Dir.Text);
In_JSON.AddPair('WWW',               TJSONBool.Create(CB_WWW.Checked));
In_JSON.AddPair('CHECK_DOMAIN',      TJSONBool.Create(TRUE));

In_JSON_CHILD:=TJSONObject.Create;
In_JSON_CHILD.AddPair('Create_New_Account', TJSONBool.Create(CB_New_Account.Checked));
if CB_New_Account.Checked = True   then In_JSON_CHILD.AddPair('AccountPrivateKey',  '');
if CB_New_Account.Checked = False  then In_JSON_CHILD.AddPair('AccountPrivateKey',  Base64UrlEncode(LoadCert64(E_AccountPrivateKey.Text)));
In_JSON_CHILD.AddPair('Account_ID', E_Account_ID.Text);
In_JSON.AddPair('Account', In_JSON_CHILD);

BS_JSON:=TBytesStream.Create(nil);
BS_JSON.WriteBuffer(BytesOf(In_JSON.ToJSON), Length(In_JSON.ToJSON));
In_JSON.Free;
BS_JSON.Position := 0;
BS_JSON.Seek(0,0);
Res:=EXECUTE_ACMECLIENT(BS_JSON.Memory, BS_JSON.Size, P_OUT_JSON, OUT_JSON_LEN);
FreeAndNil(BS_JSON);


if (P_OUT_JSON <> nil) and (OUT_JSON_LEN > 0) then begin
BS_JSON:=TBytesStream.Create(nil);
BS_JSON.WriteBuffer(P_OUT_JSON^, OUT_JSON_LEN);
BS_JSON.Position := 0;
BS_JSON.Seek(0,0);
Out_JSON:=TJSONObject.Create;
Out_JSON.Parse(BS_JSON.Bytes, 0);
BS_JSON.SaveToFile('CERT_JSON.json');
//if Res = 0 then begin
E_Account_ID.Text:= Out_JSON.Values['Account_ID'].Value;
//Out_JSON.Values['SUBJECT'].Value;
//Out_JSON.Values['ISSUER'].Value;
//Out_JSON.Values['Domain'].Value;
//Out_JSON.Values['CERT_SN'].Value;
L_Before.Caption:=Out_JSON.Values['Before'].Value;
L_After.Caption:=Out_JSON.Values['After'].Value;

for ArrayElement in Out_JSON.GetValue<TJSONArray>('Certificates') do begin
if Length(ArrayElement.GetValue<String>('AccountPrivateKey')) > 0 then
SaveCert(ArrayElement.GetValue<String>('AccountPrivateKey'),  GetCertDir() + 'AccountPrivateKey.pem');
if Length(ArrayElement.GetValue<String>('PrivateKey')) > 0 then
SaveCert(ArrayElement.GetValue<String>('PrivateKey'), GetCertDir() + 'PrivateKey.pem');
if Length(ArrayElement.GetValue<String>('CERT')) > 0 then
SaveCert(ArrayElement.GetValue<String>('CERT'), GetCertDir() + 'CERT.pem');
if Length(ArrayElement.GetValue<String>('CA')) > 0 then
SaveCert(ArrayElement.GetValue<String>('CA'), GetCertDir() + 'CA.pem');
if Length(ArrayElement.GetValue<String>('OTHER')) > 0 then
SaveCert(ArrayElement.GetValue<String>('OTHER'), GetCertDir() + 'OTHER.pem');
if Length(ArrayElement.GetValue<String>('CERT_P12')) > 0 then
SaveCert(ArrayElement.GetValue<String>('CERT_P12'), GetCertDir() + 'CERT_P12.P12');
end;


//end
//else
if Res = 1 then ShowMessage(Out_JSON.Values['ERROR'].Value);


Out_JSON.Free;
FreeAndNil(BS_JSON);
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
E_CA.Text:=SelectFile('CA Certificate (in PEM Format)');
end;

procedure TFMain.SB_Open_CertClick(Sender: TObject);
begin
E_Certificate.Text:=SelectFile('Certificate (in PEM Format)');
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
E_PrivateKey.Text:=SelectFile('Private Key (in PEM Format)');
end;

procedure TFMain.SpeedButton1Click(Sender: TObject);
begin
E_AccountPrivateKey.Text:=SelectFile('AccountPrivateKey (in PEM Format)');
end;

end.
