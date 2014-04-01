object DM1: TDM1
  OldCreateOrder = False
  Left = 813
  Top = 382
  Height = 150
  Width = 277
  object MainMenu1: TMainMenu
    Left = 24
    Top = 8
    object NFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object NFileExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = NFileExitClick
      end
    end
    object NOptions: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      object NOptionsAlphaBlend: TMenuItem
        AutoCheck = True
        Caption = #1055#1086#1103#1074#1083#1077#1085#1080#1077' '#1092#1086#1088#1084#1099
      end
      object NOptionsFont: TMenuItem
        Caption = #1064#1088#1080#1092#1090
        OnClick = NOptionsFontClick
      end
    end
    object NHelp: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object NHelpAbout: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = NHelpAboutClick
      end
    end
  end
  object FD1: TFontDialog
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    Left = 72
    Top = 8
  end
  object OD1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 120
    Top = 8
  end
  object OPD1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 168
    Top = 8
  end
  object SD1: TSaveDialog
    Filter = #1079#1072#1096#1080#1092#1088#1086#1074#1072#1085#1099#1081' '#1092#1072#1081#1083'|*.GCF'
    Left = 216
    Top = 8
  end
end
