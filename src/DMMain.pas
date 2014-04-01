unit DMMain;

interface

uses
  SysUtils, Classes, Menus, Dialogs, ExtDlgs, ExtCtrls, Windows, Messages;

type
  TDM1 = class(TDataModule)
    MainMenu1: TMainMenu;
    NFile: TMenuItem;
    NFileExit: TMenuItem;
    NOptions: TMenuItem;
    NHelp: TMenuItem;
    NOptionsAlphaBlend: TMenuItem;
    NOptionsFont: TMenuItem;
    NHelpAbout: TMenuItem;
    FD1: TFontDialog;
    OD1: TOpenDialog;
    OPD1: TOpenPictureDialog;
    SD1: TSaveDialog;
    procedure NFileExitClick(Sender: TObject);
    procedure NOptionsFontClick(Sender: TObject);
    procedure NHelpAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM1: TDM1;

implementation

{$R *.dfm}
uses
  UMain, UAbout, Forms;

procedure TDM1.NFileExitClick(Sender: TObject);
begin
  if UMain.FMain.CloseQuery then
    UMain.FMain.Close;
end;

procedure TDM1.NOptionsFontClick(Sender: TObject);
begin
  FD1.Font:=UMain.FMain.Font;
  FD1.Execute;
  UMain.FMain.Font:=FD1.Font;
end;

procedure TDM1.NHelpAboutClick(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
  UAbout.AboutBox.ShowModal;
end;

end.
