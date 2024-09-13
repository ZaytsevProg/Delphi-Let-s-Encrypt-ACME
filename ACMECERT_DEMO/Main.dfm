object FMain: TFMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ACMECERT DEMO'
  ClientHeight = 519
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PC_Main: TPageControl
    Left = 0
    Top = 0
    Width = 540
    Height = 519
    Cursor = crHandPoint
    ActivePage = TAB_ConvertCert
    Align = alClient
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object TAB_GenerateLE: TTabSheet
      Caption = 'Let'#39's Encrypt Certificate'
      object Label1: TLabel
        Left = 40
        Top = 24
        Width = 47
        Height = 16
        Caption = 'Domain'
      end
      object Label2: TLabel
        Left = 40
        Top = 96
        Width = 96
        Height = 16
        Caption = 'Account E-Mail'
      end
      object Label3: TLabel
        Left = 40
        Top = 168
        Width = 127
        Height = 16
        Caption = 'Challenge Directory'
      end
      object SB_Open_Challenge_Dir: TSpeedButton
        Left = 498
        Top = 190
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SB_Open_Challenge_DirClick
      end
      object Label10: TLabel
        Left = 40
        Top = 272
        Width = 72
        Height = 16
        Caption = 'Account ID'
      end
      object Label11: TLabel
        Left = 147
        Top = 272
        Width = 231
        Height = 16
        Caption = 'AccountPrivateKey (in PEM Format)'
      end
      object SpeedButton1: TSpeedButton
        Left = 498
        Top = 294
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SpeedButton1Click
      end
      object L_Before: TLabel
        Left = 40
        Top = 344
        Width = 43
        Height = 16
        Caption = 'Before'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_After: TLabel
        Left = 40
        Top = 376
        Width = 35
        Height = 16
        Caption = 'After'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object E_Domain: TEdit
        Left = 40
        Top = 46
        Width = 457
        Height = 24
        TabOrder = 0
      end
      object E_Mail: TEdit
        Left = 40
        Top = 118
        Width = 457
        Height = 24
        TabOrder = 1
      end
      object B_Execute_GenerateLE: TButton
        Left = 40
        Top = 416
        Width = 127
        Height = 41
        Cursor = crHandPoint
        Caption = 'Execute'
        TabOrder = 2
        OnClick = B_Execute_GenerateLEClick
      end
      object E_Challenge_Dir: TEdit
        Left = 40
        Top = 190
        Width = 460
        Height = 24
        TabOrder = 3
      end
      object CB_WWW: TCheckBox
        Left = 40
        Top = 240
        Width = 57
        Height = 17
        Cursor = crHandPoint
        Caption = 'WWW'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object CB_New_Account: TCheckBox
        Left = 120
        Top = 240
        Width = 105
        Height = 17
        Cursor = crHandPoint
        Caption = 'New Account'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object E_Account_ID: TEdit
        Left = 40
        Top = 294
        Width = 101
        Height = 24
        TabOrder = 6
      end
      object E_AccountPrivateKey: TEdit
        Left = 147
        Top = 294
        Width = 353
        Height = 24
        TabOrder = 7
      end
    end
    object TAB_ConvertCert: TTabSheet
      Caption = 'Convert Pem To P12 '
      ImageIndex = 1
      object Label4: TLabel
        Left = 40
        Top = 24
        Width = 174
        Height = 16
        Caption = 'Certificate (in PEM Format)'
      end
      object Label5: TLabel
        Left = 40
        Top = 88
        Width = 181
        Height = 16
        Caption = 'Private Key (in PEM Format)'
      end
      object Label6: TLabel
        Left = 40
        Top = 152
        Width = 196
        Height = 16
        Caption = 'CA Certificate (in PEM Format)'
      end
      object Label7: TLabel
        Left = 40
        Top = 216
        Width = 63
        Height = 16
        Caption = 'Password'
      end
      object Label8: TLabel
        Left = 256
        Top = 216
        Width = 89
        Height = 16
        Caption = 'Friendly Name'
      end
      object Label9: TLabel
        Left = 40
        Top = 288
        Width = 239
        Height = 16
        Caption = 'Save PKCS12 Certificate to Directory'
      end
      object SB_Open_Cert: TSpeedButton
        Left = 496
        Top = 46
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SB_Open_CertClick
      end
      object SB_Open_PrivateKey: TSpeedButton
        Left = 496
        Top = 110
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SB_Open_PrivateKeyClick
      end
      object SB_Open_CA: TSpeedButton
        Left = 496
        Top = 174
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SB_Open_CAClick
      end
      object SB_Open_PKCS12: TSpeedButton
        Left = 496
        Top = 310
        Width = 23
        Height = 24
        Cursor = crHandPoint
        Caption = '...'
        OnClick = SB_Open_PKCS12Click
      end
      object E_Certificate: TEdit
        Left = 40
        Top = 46
        Width = 457
        Height = 24
        TabOrder = 0
      end
      object E_PrivateKey: TEdit
        Left = 40
        Top = 110
        Width = 457
        Height = 24
        TabOrder = 1
      end
      object E_CA: TEdit
        Left = 40
        Top = 174
        Width = 457
        Height = 24
        TabOrder = 2
      end
      object E_Password: TEdit
        Left = 40
        Top = 238
        Width = 194
        Height = 24
        PasswordChar = '*'
        TabOrder = 3
      end
      object E_Friendly_Name: TEdit
        Left = 256
        Top = 238
        Width = 241
        Height = 24
        TabOrder = 4
      end
      object E_Save_PKCS12: TEdit
        Left = 40
        Top = 310
        Width = 457
        Height = 24
        TabOrder = 5
      end
      object B_Execute_Convert: TButton
        Left = 40
        Top = 376
        Width = 137
        Height = 41
        Cursor = crHandPoint
        Caption = 'Execute'
        TabOrder = 6
        OnClick = B_Execute_ConvertClick
      end
    end
  end
end
