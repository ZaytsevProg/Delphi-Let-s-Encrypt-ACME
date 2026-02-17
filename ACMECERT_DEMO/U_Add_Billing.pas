unit U_Add_Billing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TF_Add_Billing = class(TForm)
    CB_Billing_Type: TComboBox;
    E_Host: TEdit;
    E_Port: TEdit;
    E_ThumbPrint: TEdit;
    E_APPLICATION_ID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    B_Add: TButton;
    B_Cancel: TButton;
    B_GEN_APP_ID: TSpeedButton;
    procedure B_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure B_AddClick(Sender: TObject);
    procedure B_GEN_APP_IDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Add_Billing: TF_Add_Billing;

implementation

{$R *.dfm}

uses U_ACMECERT, Main;


procedure TF_Add_Billing.B_AddClick(Sender: TObject);
var
SSL_BINDING :PSET_SSL_BINDING;
ErrorBuf :PChar;
begin
ErrorBuf:=Nil;

if (Length(E_Host.Text) = 0) Or (Length(E_ThumbPrint.Text) = 0) Or (Length(E_APPLICATION_ID.Text) = 0) Or (Length(E_Port.Text) = 0) then
 Exit;

Try
  New(SSL_BINDING);
  SSL_BINDING.HOST:=StringToPAnsiChar(E_Host.Text);
  SSL_BINDING.THUMBPRINT:=StringToPAnsiChar(E_ThumbPrint.Text);
  SSL_BINDING.APP_ID:=StringToPAnsiChar(E_APPLICATION_ID.Text);
  SSL_BINDING.PORT:=StrToInt(E_Port.Text);
  if CB_Billing_Type.ItemIndex = 0 then SSL_BINDING.HOST_OR_IP:=True;
  if CB_Billing_Type.ItemIndex = 1 then SSL_BINDING.HOST_OR_IP:=False;
  SSL_BINDING.SSL_UPDATE:=False;

if not SET_SSL_BINDING(SSL_BINDING, ErrorBuf) then begin
  Messagedlg(StrPas(ErrorBuf), mterror, [mbNo], 0);
  Exit;
end
 Else begin
   FMain.Update_Billing();
   Close;
 end;

Finally
 Dispose(SSL_BINDING);
End;


end;


procedure TF_Add_Billing.B_CancelClick(Sender: TObject);
begin
Close;
end;

procedure TF_Add_Billing.B_GEN_APP_IDClick(Sender: TObject);
var
 MyGUID :TGUID;
begin
CreateGUID(MyGUID);
E_APPLICATION_ID.Text:=GuidToString(MyGUID);
end;

procedure TF_Add_Billing.FormCreate(Sender: TObject);
begin
CB_Billing_Type.ItemIndex:=0;
end;

end.
