unit U_ACMECERT;

interface

uses
 Winapi.Windows, System.SysUtils, FileCtrl;

 const
   DEFAULT_ARRAY = $FF;

  type
    TBuffer = record
       Size   :NativeInt;
       Buf    :Pointer;
    end;
      PTBuffer = ^TBuffer;

    TCREATE_ACMECERT = packed record
       LE_URL             :PAnsiChar;
       Domain             :PAnsiChar;
       E_Mail             :PAnsiChar;
       Challenge_Dir      :PAnsiChar;
       WWW                :Boolean;
    end;
      PCREATE_ACMECERT = ^TCREATE_ACMECERT;

    TACCOUNT = packed record
       New_Account        :Boolean;
       Account_URL        :PAnsiChar;
       AccountPrivateKey  :TBuffer;
    end;
      PACCOUNT = ^TACCOUNT;

    TACMECERT = packed record
       SUBJECT           :PAnsiChar;
       ISSUER            :PAnsiChar;
       SN                :PAnsiChar;
       DT_BEFORE         :Int64;
       DT_AFTER          :Int64;
       URL_Certificate   :PAnsiChar;
       PrivateKey        :TBuffer;
       CERT              :TBuffer;
       CA                :TBuffer;
       OTHER             :TBuffer;
       P12_ADD_CA        :Boolean;
       CERT_P12          :TBuffer;
    end;
      PACMECERT = ^TACMECERT;

    TPEM_To_PKCS12 = packed record
       CERT          :TBuffer;
       PKEY          :TBuffer;
       CA            :TBuffer;
       Password      :PAnsiChar;
       Friendly_Name :PAnsiChar;
    end;
      PPEM_To_PKCS12 = ^TPEM_To_PKCS12;

    TSET_SSL_BINDING = packed record
      HOST       :PAnsiChar;
      THUMBPRINT :PAnsiChar;
      APP_ID     :PAnsiChar;
      PORT       :Cardinal;
      HOST_OR_IP :Boolean;
      SSL_UPDATE :Boolean;
    end;
    PSET_SSL_BINDING = ^TSET_SSL_BINDING;

    TSSL_CERTINFO = packed record
      HOST       :PAnsiChar;
      THUMBPRINT :PAnsiChar;
      APP_ID     :PAnsiChar;
      STORE_NAME :PAnsiChar;
    end;

  PTSSL_CERTINFO_ARRAY = ^TSSL_CERTINFO_Array;
  TSSL_CERTINFO_Array = array[0..DEFAULT_ARRAY] of TSSL_CERTINFO;


  function EXECUTE_CREATE_ACMECERT(CREATE_ACMECERT :PCREATE_ACMECERT; ACCOUNT :PACCOUNT;
  ACMECERT :PACMECERT; out ErrorBuf: PChar):Boolean; stdcall; external 'ACMECERT.DLL';

  function EXECUTE_CONVERT_PEM_To_PKCS12(PEM_To_PKCS12 :PPEM_To_PKCS12;
  Var PKCS12 :TBuffer; out ErrorBuf: PChar):Boolean; stdcall; external 'ACMECERT.DLL';

  procedure TBuffer_Free(Buffer :TBuffer); stdcall external 'ACMECERT.DLL';
  procedure Pointer_Free(Var P :Pointer; LEN :NativeInt); stdcall external 'ACMECERT.DLL';


  function SET_SSL_BINDING(const SSL_BINDING :PSET_SSL_BINDING; out ErrorBuf :PChar):Boolean; stdcall; external 'ACMECERT.DLL';
  function DELETE_SSL_BINDING(const Host :PAnsiChar; const Port :Cardinal; const HOST_OR_IP :Boolean; out ErrorBuf :PChar):Boolean; stdcall; external 'ACMECERT.DLL';
  function GET_SSL_CERTINFO_IP(out SSL_CERTINFO_ARRAY :PTSSL_CERTINFO_ARRAY; out Count :Word; out ErrorBuf :PChar):Boolean; stdcall; external 'ACMECERT.DLL';
  function GET_SSL_CERTINFO_HOST(out SSL_CERTINFO_ARRAY :PTSSL_CERTINFO_ARRAY; out Count :Word; out ErrorBuf :PChar):Boolean; stdcall; external 'ACMECERT.DLL';
  procedure FREE_SSL_CERTINFO_ARRAY(const Count: Integer; var SSL_CERTINFO_ARRAY: PTSSL_CERTINFO_ARRAY); stdcall; external 'ACMECERT.DLL';

  procedure LoadFile(const FileName :String; Var Buffer :TBuffer);
  procedure SaveFile(const FileName :String; const Buf :Pointer; const Size :NativeInt);
  function SelectDir(const Caption :String):String;
  procedure Buffer_Free(Var Buffer :TBuffer);
  function GetCertDir():String;
  function GetFileSize(const FileName :String):NativeInt;
  function StringToPAnsiChar(const S :String):PAnsiChar;
  function UDT_ToDateTime(const UDT: Int64):TDateTime;


implementation


procedure LoadFile(const FileName :String; Var Buffer :TBuffer);
var
Handle: NativeInt;
Begin
Buffer.Size:=0;
Buffer.Buf:=Nil;
if FileName.Length = 0 then Exit;

Buffer.Size:=GetFileSize(FileName);
if Buffer.Size = 0 then Exit;

Handle:=FileOpen(FileName, fmOpenRead);
FileSeek(Handle,0,0);
GetMem(Buffer.Buf, Buffer.Size);
FileRead(Handle, Buffer.Buf^, Buffer.Size);
FileClose(Handle);
End;

procedure SaveFile(const FileName :String; const Buf :Pointer; const Size :NativeInt);
var
Handle: NativeInt;
Begin
if (Size  = 0) OR (FileName.Length = 0) OR (Buf = Nil) then Exit;

Handle:=FileCreate(FileName);
FileWrite(Handle, Buf^, Size);
FileClose(Handle);
End;

function SelectDir(const Caption :String):String;
begin
SelectDirectory(Caption, '', Result, [sdNewUI, sdShowEdit]);
if Length(Result) = 0 then Exit;
Result:=Result +'\';
end;

procedure Buffer_Free(Var Buffer :TBuffer);
Begin
if (Buffer.Size > 0) And (Buffer.Buf <> Nil) then
FreeMem(Buffer.Buf, Buffer.Size);
Buffer.Buf:=Nil;
Buffer.Size:=0;
End;

function GetCertDir():String;
begin
Result:=ExtractFilePath(ParamStr(0)) +'CERT\';
if not DirectoryExists(Result) then createdir(Result);
end;

function GetFileSize(const FileName :String):NativeInt;
var
Info :TWin32FileAttributeData;
begin
Result:=0;
if not GetFileAttributesEx(PWideChar(FileName), GetFileExInfoStandard, @Info) then Exit;
Result:=Int64(Info.nFileSizeLow) Or Int64(Info.nFileSizeHigh shl 32);
end;

function StringToPAnsiChar(const S :String):PAnsiChar;
Begin
Result:=AnsiStrAlloc(Length(S)+1);
StrPCopy(Result, S);
End;

function UDT_ToDateTime(const UDT: Int64):TDateTime;
begin
Result := (UDT / 86400) + 25569;
end;

end.