object F_Add_Billing: TF_Add_Billing
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add Billing'
  ClientHeight = 173
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 38
    Width = 82
    Height = 13
    Caption = 'HOSTNAME/IP:'
  end
  object Label2: TLabel
    Left = 351
    Top = 38
    Width = 27
    Height = 13
    Caption = 'Port:'
  end
  object Label3: TLabel
    Left = 26
    Top = 65
    Width = 69
    Height = 13
    Caption = 'ThumbPrint:'
  end
  object Label4: TLabel
    Left = 1
    Top = 94
    Width = 94
    Height = 13
    HelpContext = 1
    Caption = 'APPLICATION ID:'
  end
  object B_GEN_APP_ID: TSpeedButton
    Left = 344
    Top = 89
    Width = 23
    Height = 21
    Cursor = crHandPoint
    Caption = '...'
    OnClick = B_GEN_APP_IDClick
  end
  object CB_Billing_Type: TComboBox
    Left = 99
    Top = 8
    Width = 121
    Height = 22
    Cursor = crHandPoint
    Style = csOwnerDrawFixed
    TabOrder = 0
    Items.Strings = (
      'HOST'
      'IP')
  end
  object E_Host: TEdit
    Left = 99
    Top = 35
    Width = 246
    Height = 21
    TabOrder = 1
  end
  object E_Port: TEdit
    Left = 384
    Top = 35
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '443'
  end
  object E_ThumbPrint: TEdit
    Left = 99
    Top = 62
    Width = 246
    Height = 21
    TabOrder = 3
  end
  object E_APPLICATION_ID: TEdit
    Left = 99
    Top = 89
    Width = 246
    Height = 21
    TabOrder = 4
  end
  object B_Add: TButton
    Left = 99
    Top = 128
    Width = 121
    Height = 36
    Cursor = crHandPoint
    Caption = 'Add'
    TabOrder = 5
    OnClick = B_AddClick
  end
  object B_Cancel: TButton
    Left = 224
    Top = 128
    Width = 121
    Height = 36
    Cursor = crHandPoint
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = B_CancelClick
  end
end
