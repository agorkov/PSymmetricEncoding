object FErrors: TFErrors
  Left = 205
  Top = 131
  Width = 416
  Height = 344
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1086#1096#1080#1073#1086#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    9999999999999999999999999999999999999999999999999999999999999900
    0000000000000000000000000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000000000000000000000000000999999
    9999999999999999999999999999999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 385
    Height = 217
    TabOrder = 0
  end
  object BBExit: TBitBtn
    Left = 8
    Top = 264
    Width = 385
    Height = 41
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    Kind = bkClose
  end
  object Edit1: TEdit
    Left = 272
    Top = 232
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'C:\CryptoErrors'
  end
  object Button1: TButton
    Left = 8
    Top = 232
    Width = 257
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1095#1105#1090' '#1074' ...'
    TabOrder = 3
    OnClick = Button1Click
  end
end