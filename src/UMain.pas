unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, FileCtrl, OleCtnrs;

type
  TFMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    LEPass1: TLabeledEdit;
    LEPass2: TLabeledEdit;
    LFileName: TLabel;
    PBFiles: TProgressBar;
    PBFolder: TProgressBar;
    PCMain: TPageControl;
    TSFiles: TTabSheet;
    BBCrypt: TBitBtn;
    BBDeCrypt: TBitBtn;
    BBFilesToCrypt: TBitBtn;
    CheckBox1: TCheckBox;
    BBFilesToDeCrypt: TBitBtn;
    TSFolders: TTabSheet;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    BBCryptFolder: TBitBtn;
    BBDeCryptFolder: TBitBtn;
    BBErrors: TBitBtn;
    CheckBox2: TCheckBox;
    BBStop: TBitBtn;
    LFolder: TLabel;
    TSStegano: TTabSheet;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    TSMail: TTabSheet;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    OleContainer1: TOleContainer;
    BitBtn2: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure BBCryptClick(Sender: TObject);
    procedure BBFilesToCryptClick(Sender: TObject);
    procedure BBDeCryptClick(Sender: TObject);
    procedure BBFilesToDeCryptClick(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure BBCryptFolderClick(Sender: TObject);
    procedure BBDeCryptFolderClick(Sender: TObject);
    procedure BBErrorsClick(Sender: TObject);
    procedure TSFilesShow(Sender: TObject);
    procedure TSFoldersShow(Sender: TObject);
    procedure BBStopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TSSteganoShow(Sender: TObject);
    procedure TSMailShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TRestoreFile= file of Cardinal;
  function Crypt(FileName,Password: string): byte; stdcall; EXTERNAL 'CryptLib.dll';
  function DeCrypt(FileName,Password: string): byte; stdcall; EXTERNAL 'CryptLib.dll';
  function SaveToFile(FileName,Msg: string): byte; stdcall; EXTERNAL 'SteganoLib.dll';
  function ReadFromFile(FileName: string): string; stdcall; EXTERNAL 'SteganoLib.dll';

const
  ProgramName='Crypto';

var
  FMain: TFMain;
  Alpha: boolean;
  Folders: TStringList;
  Errors: TStringList;
  Stop: boolean;

implementation

{$R *.dfm}
uses
  DMMain, UReg, UAbout, UErrors, ClipBrd;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
i: byte;
begin
  UReg.WriteBool(ProgramName,'Alpha',DMMain.DM1.NOptionsAlphaBlend.Checked);
  if DMMain.DM1.NOptionsAlphaBlend.Checked then
  begin
    FMain.AlphaBlend:=true;
    for i:=255 downto 1 do
    begin
      FMain.AlphaBlendValue:=i;
      FMain.Refresh;
    end;
  end;
  UReg.SaveFont(FMain);
  Errors.Free;
end;

procedure TFMain.FormActivate(Sender: TObject);
var
i: byte;
begin
  Stop:=false;
  FMain.Refresh;
  DMMain.DM1.NOptionsAlphaBlend.Checked:=UReg.ReadBool(ProgramName,'Alpha');
  if (DMMain.DM1.NOptionsAlphaBlend.Checked)and(not Alpha) then
  begin
    Alpha:=true;
    FMain.AlphaBlend:=true;
    FMain.AlphaBlendValue:=1;
    for i:=1 to 255 do
    begin
      FMain.AlphaBlendValue:=i;
      FMain.Refresh;
    end;
  end;
  //UReg.CheckRegistration(ProgramName);
  UReg.ReadFont(FMain);
  if ParamCount>0 then
  begin
    DMMain.DM1.OD1.FileName:=ParamStr(1);
    DirectoryListBox1.Drive:=ParamStr(1)[1];
    DirectoryListBox1.Directory:=ParamStr(1);
  end;
  Errors:=TStringList.Create;
end;

function BeforeCrypt(FileName: string): byte;
begin
  Result:=0;
  if UMain.FMain.LEPass1.Text='' then
    Result:=1;
  if UMain.FMain.LEPass1.Text<>UMain.FMain.LEPass2.Text then
    Result:=2;
end;

function AfterCrypt(FileName: string): byte;
var
  f: TRestoreFile;
  FIn: file;
  vr: Cardinal;
begin
  result:=0;
  try
    if UMain.FMain.CheckBox1.Checked then
    begin
      AssignFile(f,FileName+'.GRF');
      ReWrite(f);
      vr:=UReg.CreateGBF(UMain.FMain.LEPass1.Text);
      Write(f,vr);
      CloseFile(f);
    end;
  except
    Result:=1;
  end;
  try
    AssignFile(FIn,FileName);
    ReName(FIn,FileName+'.GCF');
  except
    Result:=2;
  end;
end;

function BeforeDeCrypt(FileName: string): byte;
var
  f: TRestoreFile;
  vr: Cardinal;
  dir: string;
  k: byte;
begin
  Result:=0;
  try
    if UMain.FMain.CheckBox1.Checked then
    begin
      dir:=FileName;
      k:=pos('.GCF',FileName);
      delete(dir,k,4);
      AssignFile(f,dir+'.GRF');
      Reset(f);
      Read(f,vr);
      CloseFile(f);
      if vr<>UReg.CreateGBF(UMain.FMain.LEPass1.Text) then
        Result:=1;
    end;
  except
    Result:=2;
  end;
end;

function AfterDeCrypt(FileName: string): byte;
var
  f: file;
  dir: string;
  k: byte;
begin
  Result:=0;
  try
    if FileExists(FileName) then
    begin
      dir:=FileName;
      k:=pos('.GCF',FileName);
      delete(dir,k,4);
      AssignFile(f,dir+'.GRF');
      Erase(f);
    end
    else
      Result:=2;
  except
    Result:=1;
  end;
  try
    AssignFile(f,FileName);
    ReName(f,dir);
  except
    Result:=2;
  end;
end;

procedure TFMain.BBCryptClick(Sender: TObject);
var
i: word;
label
1;
begin
  BBErrors.Visible:=true;
  1:
  if (DMMain.DM1.OD1.Files.Count=0)and(DMMain.DM1.OD1.FileName='') then
  begin
    if MessageDlg('Хотите выбрать файлы?',mtConfirmation,[mbYes,mbNo],0)=6 then
    begin
      UMain.FMain.BBFilesToCryptClick(Sender);
      goto 1;
    end
    else
      Exit;
  end;

  PBFiles.Max:=DMMain.DM1.OD1.Files.Count-1;
  for i:=0 to DMMain.DM1.OD1.Files.Count-1 do
  begin
    begin{Проверка перед шифровкой}
      LFileName.Caption:=DMMain.DM1.OD1.Files[i];
      FMain.Refresh;
      case BeforeCrypt(DMMain.DM1.OD1.Files[i]) of
        1:
        begin
          ShowMessage('Пустой пароль');
          exit;
        end;
        2:
        begin
          ShowMessage('Пароль и подтверждение пароля не совпадают');
          exit;
        end;
      end;{case}
    end;{Проверка перед шифровкой}
    begin{Собственно шифровка}
      Application.ProcessMessages;
      if Stop then
      begin
        ShowMessage('Процесс прерван');
        PBFiles.Position:=0;
        PBFolder.Position:=0;
        Exit;
      end;
      case Crypt(DMMain.DM1.OD1.Files[i],LEPass1.Text) of
      1:
      begin
        ShowMessage('Невозможно открыть файл');
        Continue;
      end;
      2:
      begin
        Errors.Add('Ошибка отображения файла '+DMMain.DM1.OD1.Files[i]);
        Continue;
      end;
      3:
      begin
        Errors.Add('Ошибка создания окна просмотра '+DMMain.DM1.OD1.Files[i]);
        Continue;
      end;
      end;{case}
    end;{Собственно шифровка}
    begin{Завершение шифровки}
      case AfterCrypt(DMMain.DM1.OD1.Files[i]) of
        1:
        begin
          Errors.Add('Невозможно создать файл проверки пароля '+DMMain.DM1.OD1.Files[i]);
        end;
        2:
        begin
          Errors.Add('Невозможно переименовать файл '+DMMain.DM1.OD1.Files[i]);
        end;
      end;{case}
      LFileName.Caption:='';
      FMain.Refresh;
      PBFiles.Position:=PBFiles.Max-i;
    end;{Завершение шифровки}
  end;
  PBFiles.Position:=0;
  DMMain.DM1.OD1.Files.Clear;
  DMMain.DM1.OD1.FileName:='';
end;

procedure TFMain.BBFilesToCryptClick(Sender: TObject);
begin
  DMMain.DM1.OD1.Files.Clear;
  DMMain.DM1.OD1.Filter:='любой файл | *.*';
  DMMain.DM1.OD1.Execute;
end;

procedure TFMain.BBDeCryptClick(Sender: TObject);
var
i: word;
label
1;
begin
  BBErrors.Visible:=true;
  1:
  if (DMMain.DM1.OD1.Files.Count=0)and(DMMain.DM1.OD1.FileName='') then
  begin
    if MessageDlg('Хотите выбрать файлы?',mtConfirmation,[mbYes,mbNo],0)=6 then
    begin
      UMain.FMain.BBFilesToDeCryptClick(Sender);
      goto 1;
    end
    else
      Exit;
  end;
  PBFiles.Max:=DMMain.DM1.OD1.Files.Count-1;
  for i:=0 to DMMain.DM1.OD1.Files.Count-1 do
  begin
    begin{Проверка перед дешифровкой}
      LFileName.Caption:=DMMain.DM1.OD1.Files[i];
      FMain.Refresh;
      case BeforeDeCrypt(DMMain.DM1.OD1.Files[i]) of
        2:
        begin
          Errors.Add('Невозможно проверить пароль');
          if MessageDlg('Невозможно проверить пароль! '+#10#13+' Хотите продолжить?',mtConfirmation,[mbYes,mbNo],0)=6 then
            CheckBox1.Checked:=false
          else
            exit;
        end;
        1:
        begin
          ShowMessage('Неверный пароль '+DMMain.DM1.OD1.Files[i]);
          exit;
        end;
      end;{case}
    end;{Проверка перед дешифровкой}
    begin{Собственно дешифровка}
      Application.ProcessMessages;
      if Stop then
      begin
        ShowMessage('Процесс прерван');
        PBFiles.Position:=0;
        PBFolder.Position:=0;
        Exit;
      end;
      case DeCrypt(DMMain.DM1.OD1.Files[i],LEPass1.Text) of
      1:
      begin
        Errors.Add('Невозможно открыть файл '+DMMain.DM1.OD1.Files[i]);
        Continue;
      end;
      2:
      begin
        Errors.Add('Ошибка отображения файла '+DMMain.DM1.OD1.Files[i]);
        Continue;
      end;
      3:
      begin
        Errors.Add('Ошибка создания окна просмотра '+DMMain.DM1.OD1.Files[i]);
        Continue;
      end;
      end;{case}
    end;{Собственно дешифровка}
    begin{Завершение дешифровки}
      case AfterDeCrypt(DMMain.DM1.OD1.Files[i]) of
        1:
        begin
          Errors.Add('Неопределённая ошибка '+DMMain.DM1.OD1.Files[i]);
        end;
        2:
        begin
          Errors.Add('Нельзя переименовать файл '+DMMain.DM1.OD1.Files[i]);
        end;
      end;{case}
      LFileName.Caption:='';
      FMain.Refresh;
      PBFiles.Position:=PBFiles.Max-i;
    end;{Завершение шифровки}
  end;
  PBFiles.Position:=0;
  DMMain.DM1.OD1.Files.Clear;
  DMMain.DM1.OD1.FileName:='';
end;

procedure TFMain.BBFilesToDeCryptClick(Sender: TObject);
begin
  DMMain.DM1.OD1.Files.Clear;
  DMMain.DM1.OD1.Filter:='зашифрованый файл | *.GCF';
  DMMain.DM1.OD1.Execute;
end;

procedure TFMain.DriveComboBox1Change(Sender: TObject);
begin
  DirectoryListBox1.Drive:=DriveComboBox1.Drive;
end;

procedure TFMain.BBCryptFolderClick(Sender: TObject);
var
num: word;
SR, SR2: TSearchRec;
i: byte;
str: string;
label
1,2;
begin
  if LEPass1.Text<>LEPass2.Text then
  begin
    ShowMessage('Пароль и подтверждение пароля не совпадают');
    exit;
  end;
  Folders:=TStringList.Create;
  Folders.Clear;
  str:=DirectoryListBox1.Directory;
  if str[length(str)]='\' then
  begin
    delete(str,length(str),1);
  end;
  num:=0;
  Folders.Add(str);
  if FindFirst(str+'\*.*',faAnyFile,SR)=0 then
  while FindNext(SR)=0 do
  begin
    if (SR.Attr=faDirectory)and(SR.Name<>'.')and(SR.Name<>'..') then
      Folders.Add(str+'\'+SR.Name);
    if (SR.Attr=17)and(SR.Name<>'.')and(SR.Name<>'..') then
      Folders.Add(str+'\'+SR.Name);
  end;

  1:
  FindClose(SR);
  inc(num);
  if num>Folders.Count-1 then
    goto 2;
  if FindFirst(Folders[num]+'\*.*',faAnyFile,SR)=0 then
    for i:=num to Folders.Count-1 do
      begin
        while FindNext(SR)=0 do
        begin
          if (SR.Attr=faDirectory)and(SR.Name<>'.')and(SR.Name<>'..') then
            Folders.Add(Folders[num]+'\'+SR.Name);
          if (SR.Attr=17)and(SR.Name<>'.')and(SR.Name<>'..') then
            Folders.Add(Folders[num]+'\'+SR.Name);
        end
      end
  else
    begin
    end;
  goto 1;

  2:
  num:=0;
  PBFolder.Max:=Folders.Count-1;
  PBFolder.Position:=PBFolder.Max;
  for i:=0 to Folders.Count-1 do
  begin
    DMMain.DM1.OD1.Files.Clear;
    LFolder.Caption:=Folders[i];
    FMain.Refresh;
    if FindFirst(Folders[i]+'\*.*',faAnyFile xor faDirectory,SR2)=0 then
      repeat
        if (SR2.Name='.')or(SR2.Name='..') then
          Continue;
        DMMain.DM1.OD1.Files.Add(Folders[i]+'\'+SR2.Name);
      until FindNext(SR2)<>0;
    FindClose(SR2);
    if DMMain.DM1.OD1.Files.Count<>0 then
    begin
      UMain.FMain.BBCryptClick(Sender);
      if Stop then
        Exit;
    end;
    inc(num);
    PBFolder.Position:=PBFolder.Max-num;
  end;
  PBFolder.Position:=0;
  LFolder.Caption:='';
  Folders.Free;
  if CheckBox2.Checked then
    FMain.Close
  else
    FMain.BBErrorsClick(Sender);
end;

procedure TFMain.BBDeCryptFolderClick(Sender: TObject);
var
num: word;
SR, SR2: TSearchRec;
i: byte;
str: string;
label
1,2;
begin
  Folders:=TStringList.Create;
  Folders.Clear;
  str:=DirectoryListBox1.Directory;
  if str[length(str)]='\' then
  begin
    delete(str,length(str),1);
  end;
  num:=0;
  Folders.Add(str);
  if FindFirst(str+'\*.*',faAnyFile,SR)=0 then
  while FindNext(SR)=0 do
  begin
    if (SR.Attr=faDirectory)and(SR.Name<>'.')and(SR.Name<>'..') then
      Folders.Add(str+'\'+SR.Name);
    if (SR.Attr=17)and(SR.Name<>'.')and(SR.Name<>'..') then
      Folders.Add(str+'\'+SR.Name);
  end;

  1:
  FindClose(SR);
  inc(num);
  if num>Folders.Count-1 then
    goto 2;
  if FindFirst(Folders[num]+'\*.*',faAnyFile,SR)=0 then
    for i:=num to Folders.Count-1 do
      begin
        while FindNext(SR)=0 do
        begin
          if (SR.Attr=faDirectory)and(SR.Name<>'.')and(SR.Name<>'..') then
            Folders.Add(Folders[num]+'\'+SR.Name);
          if (SR.Attr=17)and(SR.Name<>'.')and(SR.Name<>'..') then
            Folders.Add(Folders[num]+'\'+SR.Name);
        end
      end
  else
    begin
    end;
  goto 1;

  2:
  num:=0;
  PBFolder.Max:=Folders.Count-1;
  PBFolder.Position:=PBFolder.Max;
  for i:=0 to Folders.Count-1 do
  begin
    DMMain.DM1.OD1.Files.Clear;
    LFolder.Caption:=Folders[i];
    FMain.Refresh;
    if FindFirst(Folders[i]+'\*.GCF',faAnyFile xor faDirectory,SR2)=0 then
      repeat
        if (SR2.Name='.')or(SR2.Name='..') then
          Continue;
        DMMain.DM1.OD1.Files.Add(Folders[i]+'\'+SR2.Name);
      until FindNext(SR2)<>0;
    FindClose(SR2);
    if DMMain.DM1.OD1.Files.Count<>0 then
    begin
      UMain.FMain.BBDeCryptClick(Sender);
      if Stop then
        Exit;
    end;
    inc(num);
    PBFolder.Position:=PBFolder.Max-num;
  end;
  PBFolder.Position:=0;
  LFolder.Caption:='';
  Folders.Free;
  if CheckBox2.Checked then
    FMain.Close
  else
    FMain.BBErrorsClick(Sender);
end;

procedure TFMain.BBErrorsClick(Sender: TObject);
begin
  UErrors.FErrors.ShowModal;
end;

procedure TFMain.TSFilesShow(Sender: TObject);
begin
  CheckBox2.Checked:=false;
  CheckBox2.Enabled:=false;
end;

procedure TFMain.TSFoldersShow(Sender: TObject);
begin
  CheckBox2.Enabled:=true;
end;

procedure TFMain.BBStopClick(Sender: TObject);
begin
  if not Stop then
  begin
    Stop:=true;
    BBStop.Caption:='Запустить'
  end
  else
  begin
    Stop:=false;
    BBStop.Caption:='Стоп';
  end;
end;

procedure TFMain.Button1Click(Sender: TObject);
label
1;
begin
  1:
  DMMain.DM1.OPD1.Execute;
  if DMMain.DM1.OPD1.FileName='' then
  begin
    if MessageDlg('Хотите выбрать файлы?',mtConfirmation,[mbYes,mbNo],0)=6 then
      goto 1
    else
      Exit;
  end;
  if SaveToFile(DMMain.DM1.OPD1.FileName,Edit1.Text)=1 then
    ShowMessage('Ошибка');
end;

procedure TFMain.Button2Click(Sender: TObject);
label
1;
begin
  1:
  DMMain.DM1.OPD1.Execute;
  if DMMain.DM1.OPD1.FileName='' then
  begin
    if MessageDlg('Хотите выбрать файлы?',mtConfirmation,[mbYes,mbNo],0)=6 then
      goto 1
    else
      Exit;
  end;
  Edit1.Text:=ReadFromFile(DMMain.DM1.OPD1.FileName);
end;

procedure TFMain.BitBtn1Click(Sender: TObject);
var
TF: TextFile;
dir: string;
label
1;
begin
  1:
  dir:=ExtractFilePath (Application.ExeName);
  dir:=dir+'mail\';
  DMMain.DM1.SD1.InitialDir:=dir;
  DMMain.DM1.SD1.Execute;
  if DMMain.DM1.SD1.FileName='' then
  begin
    if MessageDlg('Хотите сохранить почту?',mtConfirmation,[mbYes,mbNo],0)=6 then
      goto 1
    else
      Exit;
  end;

  AssignFile(TF,DMMain.DM1.SD1.FileName);
  Rewrite(TF);
  CloseFile(TF);
  Memo1.Lines.SaveToFile(DMMain.DM1.SD1.FileName);
  DMMain.DM1.OD1.Files.Clear;
  DMMain.DM1.OD1.Files.Add(DMMain.DM1.SD1.FileName);
  DMMain.DM1.OD1.FileName:=DMMain.DM1.SD1.FileName;
  UMain.FMain.BBCryptClick(Sender);
  OleContainer1.DoVerb(ovShow);
  DMMain.DM1.SD1.InitialDir:='';
end;

procedure TFMain.BitBtn2Click(Sender: TObject);
var
TF: TextFile;
dir: string;
k: byte;
label
1;
begin
  1:
  DMMain.DM1.OD1.Filter:='Зашифрованный файл | *.GCF';
  dir:=ExtractFilePath (Application.ExeName);;
  dir:=dir+'mail\';
  DMMain.DM1.OD1.InitialDir:=dir;
  DMMain.DM1.OD1.Execute;
  if DMMain.DM1.OD1.FileName='' then
  begin
    if MessageDlg('Хотите прочитать почту?',mtConfirmation,[mbYes,mbNo],0)=6 then
      goto 1
    else
      Exit;
  end;
  dir:=DMMain.DM1.OD1.FileName;
  k:=pos('.GCF',DMMain.DM1.OD1.FileName);
  delete(dir,k,4);
  UMain.FMain.BBDeCryptClick(Sender);
  Memo1.Lines.LoadFromFile(dir);
  AssignFile(TF,dir);
  Erase(TF);
  DMMain.DM1.OD1.InitialDir:='';
end;

procedure TFMain.TSSteganoShow(Sender: TObject);
begin
  CheckBox2.Checked:=false;
  CheckBox2.Enabled:=false;
end;

procedure TFMain.TSMailShow(Sender: TObject);
begin
  CheckBox2.Checked:=false;
  CheckBox2.Enabled:=false;
end;

end.
