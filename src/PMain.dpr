program PMain;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  DMMain in 'DMMain.pas' {DM1: TDataModule},
  UAbout in 'UAbout.pas' {AboutBox},
  UCrypt in 'UCrypt.pas',
  UErrors in 'UErrors.pas' {FErrors};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Crypt';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TFErrors, FErrors);
  {Application.CreateForm(TAboutBox, AboutBox);}
  Application.Run;
end.
