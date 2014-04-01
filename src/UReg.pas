unit UReg;

interface
uses
  Forms;
function CreateGBF(str: string): LongWord;//1.
function GetSerial: string;//2.
procedure CheckRegistration(ProgramName: string);//3.
procedure RegProgram(ProgramName: string);//4.
procedure WriteBool(ProgramName: string; ValueName: string; Value: boolean);//5.
function ReadBool(ProgramName: string; ValueName: string): boolean;//6.
procedure SaveFont(Form: TForm) overload;//7.
procedure ReadFont(Form: TForm) overload;//8.
procedure WriteString(ProgramName: string; ValueName: string; Value: string);//9.
function ReadString(ProgramName: string; ValueName: string): string;//10.

implementation

uses
  Windows, SysUtils, Registry, Dialogs, UMain, Graphics;

function CreateGBF(str: string): LongWord;//1.
var
i: byte;
vr: LongWord;
begin
  vr:=0;
  for i:=1 to length(str) do
  begin
    vr:=vr+i*ord(str[i]);
  end;
  i:=length(str);
  vr:=vr*i;
  CreateGBF:=vr;
end;

function GetSerial: string;//2.
var
 lpRootPathName           : PChar;
 lpVolumeNameBuffer       : PChar;
 nVolumeNameSize          : DWORD;
 lpVolumeSerialNumber     : DWORD;
 lpMaximumComponentLength : DWORD;
 lpFileSystemFlags        : DWORD;
 lpFileSystemNameBuffer   : PChar;
 nFileSystemNameSize      : DWORD;

 FSectorsPerCluster: DWORD;
 FBytesPerSector   : DWORD;
 FFreeClusters     : DWORD;
 FTotalClusters    : DWORD;
begin
  lpVolumeNameBuffer      := '';
  lpVolumeSerialNumber    := 0;
  lpMaximumComponentLength:= 0;
  lpFileSystemFlags       := 0;
  lpFileSystemNameBuffer  := '';
  try
    GetMem(lpVolumeNameBuffer, MAX_PATH + 1);
    GetMem(lpFileSystemNameBuffer, MAX_PATH + 1);
    nVolumeNameSize := MAX_PATH + 1;
    nFileSystemNameSize := MAX_PATH + 1;
    lpRootPathName := PChar('C:\');
    if GetVolumeInformation( lpRootPathName, lpVolumeNameBuffer,
      nVolumeNameSize, @lpVolumeSerialNumber, lpMaximumComponentLength,
      lpFileSystemFlags, lpFileSystemNameBuffer, nFileSystemNameSize ) then
      begin
        GetSerial:= IntToHex(HIWord(lpVolumeSerialNumber), 4) + '-' + IntToHex(LOWord(lpVolumeSerialNumber), 4);
        GetDiskFreeSpace( PChar('C:\'), FSectorsPerCluster, FBytesPerSector,  FFreeClusters, FTotalClusters);
      end;
  finally
    FreeMem(lpVolumeNameBuffer);
    FreeMem(lpFileSystemNameBuffer);
  end;
end;

procedure CheckRegistration(ProgramName: string);//3.
var
Reg: TRegistry;
TGBF,TSerial,GBF,Serial: string;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  if not ((Reg.ValueExists('reg'))and(Reg.ValueExists('serial'))) then
  begin
    ShowMessage('Неполная регистрация');
    UMain.FMain.Close;
  end
  else
  begin
    TGBF:=Reg.ReadString('reg');
    TSerial:=Reg.ReadString('serial');
    GBF:=inttostr(CreateGBF(ProgramName));
    Serial:=GetSerial;
    if not ((TGBF=GBF)and(TSerial=Serial)) then
    begin
      ShowMessage('Неверная регистрация');
      UMain.FMain.Close;
    end;
  end;
  Reg.Free;
end;

procedure RegProgram(ProgramName: string);//4.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  Reg.WriteString('reg',inttostr(CreateGBF(ProgramName)));
  Reg.WriteString('serial',GetSerial);
  Reg.Free;
end;

procedure WriteBool(ProgramName: string; ValueName: string; Value: boolean);//5.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  Reg.WriteBool(ValueName,Value);
  Reg.Free;
end;

function ReadBool(ProgramName: string; ValueName: string): boolean;//6.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  if not Reg.ValueExists(ValueName) then
    Reg.WriteBool(ValueName,false);
  ReadBool:=Reg.ReadBool(ValueName);
  Reg.Free;
end;

procedure SaveFont(Form: TForm) overload;//7.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  Reg.OpenKey('Font',true);
  Reg.OpenKey(Form.Name,true);
  Reg.WriteInteger('Charset',Form.Font.Charset);
  Reg.WriteInteger('Color',Form.Font.Color);
  Reg.WriteString('Name',Form.Font.Name);
  Reg.WriteInteger('Pitch',integer(Form.Font.Pitch));
  Reg.WriteInteger('Size',Form.Font.Size);
  Reg.OpenKey('Style', true);
  if fsBold in Form.Font.Style then
    Reg.WriteBool('fsBold',true)
  else
    Reg.WriteBool('fsBold',false);

  if fsItalic in Form.Font.Style then
    Reg.WriteBool('fsItalic',true)
  else
    Reg.WriteBool('fsItalic',false);

  if fsUnderline in Form.Font.Style then
    Reg.WriteBool('fsUnderline',true)
  else
    Reg.WriteBool('fsUnderline',false);

  if fsStrikeOut in Form.Font.Style then
    Reg.WriteBool('fsStrikeOut',true)
  else
    Reg.WriteBool('fsStrikeOut',false);
  Reg.Free;
end;

procedure ReadFont(Form: TForm) overload;//8.
var
Reg: TRegistry;
v1,v2,v3,v4: TFontStyles;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  Reg.OpenKey('Font',true);
  Reg.OpenKey(Form.Name,true);
  if not Reg.ValueExists('Charset') then
    Exit;
  Form.Font.Charset:=Reg.ReadInteger('Charset');
  Form.Font.Color:=Reg.ReadInteger('Color');
  Form.Font.Name:=Reg.ReadString('Name');
  Form.Font.Pitch:=TFontPitch(Reg.ReadInteger('Pitch'));
  Form.Font.Size:=Reg.ReadInteger('Size');
  Reg.OpenKey('Style',true);
  if Reg.ReadBool('fsBold') then
    v1:=[fsBold]
  else
    v1:=[];
  if Reg.ReadBool('fsItalic') then
    v2:=[fsItalic]
  else
    v2:=[];
  if Reg.ReadBool('fsUnderline') then
    v3:=[fsUnderline]
  else
    v3:=[];
  if Reg.ReadBool('fsStrikeout') then
    v4:=[fsStrikeOut]
  else
    v4:=[];
  Form.Font.Style:=v1+v2+v3+v4;
  Reg.Free;
end;

procedure WriteString(ProgramName: string; ValueName: string; Value: string);//9.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  Reg.WriteString(ValueName,Value);
  Reg.Free;
end;

function ReadString(ProgramName: string; ValueName: string): string;//10.
var
Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.OpenKey('Software',true);
  Reg.OpenKey('Gorkoff A.',true);
  Reg.OpenKey(ProgramName,true);
  if not Reg.ValueExists(ValueName) then
    Reg.WriteString(ValueName,'');
  ReadString:=Reg.ReadString(ValueName);
  Reg.Free;
end;

end.
