unit UCrypt;

interface
function Crypt(FileName, password: string): byte;//1.
function DeCrypt(FileName, password: string): byte;//2.

implementation

uses
  SysUtils, Windows;

type
  PByte=^Byte;

function Crypt(FileName, password: string): byte;//1.
var
FIn, FInO: THandle;
p: pointer;
vr: PByte;
i: Cardinal;
j: byte;
FileSize: Cardinal;
begin
  begin{Подготовка к шифровке}
    Result:=0;
    i:=0;
    j:=0;
    FIn:=FileOpen(FileName,fmOpenReadWrite);
    if FIn=0 then
    begin
      Result:=1;
      exit;
    end;
    FileSize:=GetFileSize(FIn,nil);
    FInO:=CreateFileMapping(FIn,nil,PAGE_READWRITE,0,FileSize,nil);
    if FInO=0 then
    begin
      Result:=2;
      exit;
    end;
    p:=MapViewOfFile(FInO,FILE_MAP_WRITE,0,0,FileSize);
    if p=nil then
    begin
      Result:=3;
      exit;
    end;
    vr:=p;
  end;{Подготовка к шифровке}
  begin{Шифровка}
    while i<FileSize do
    begin
      inc(i);
      inc(j);
      if j>length(password) then
        j:=1;
      vr^:=vr^+ord(password[j]);
      vr:=Pointer(Integer(vr)+SizeOf(byte));
    end;
  end;{Шифровка}
  begin{Завершение шифровки}
    UnMapViewOfFile(p);
    CloseHandle(FInO);
    CloseHandle(FIn);
  end;{Завершение шифровки}
end;

function DeCrypt(FileName, password: string): byte;//2.
var
FIn, FInO: THandle;
p: pointer;
vr: PByte;
i: Cardinal;
j: byte;
FileSize: Cardinal;
begin
  begin{Подготовка к дешифровке}
    Result:=0;
    i:=0;
    j:=0;
    FIn:=FileOpen(FileName,fmOpenReadWrite);
    if FIn=0 then
    begin
      Result:=1;
      exit;
    end;
    FileSize:=GetFileSize(FIn,nil);
    FInO:=CreateFileMapping(FIn,nil,PAGE_READWRITE,0,FileSize,nil);
    if FInO=0 then
    begin
      Result:=2;
      exit;
    end;
    p:=MapViewOfFile(FInO,FILE_MAP_WRITE,0,0,FileSize);
    if p=nil then
    begin
      Result:=3;
      exit;
    end;
    vr:=p;
  end;{Подготовка к дешифровке}
  begin{Дешифровка}
    while i<FileSize do
    begin
      inc(i);
      inc(j);
      if j>length(password) then
        j:=1;
      vr^:=vr^-ord(password[j]);
      vr:=Pointer(Integer(vr)+SizeOf(byte));
    end;
  end;{Дешифровка}
  begin{Завершение дешифровки}
    UnMapViewOfFile(p);
    CloseHandle(FInO);
    CloseHandle(FIn);
  end;{Завершение дешифровки}
end;

end.
