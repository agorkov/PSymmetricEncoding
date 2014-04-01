library SteganoLib;

uses
  SysUtils,
  Classes;

{$R *.res}

function SaveToFile(FileName,Msg: string): byte; stdcall;
var
f: TFileStream;
MsgSize, Offset, i: LongWord;
begin
  Result:=0;
  try
    f:=TFileStream.Create(FileName,fmOpenReadWrite);
    f.Seek(6,0);
    MsgSize:=length(Msg);
    f.Write(MsgSize,SizeOf(MsgSize));
    f.Read(Offset,SizeOf(OffSet));
    f.Seek(Offset,0);
    for i:=1 to MsgSize do
      f.Write(Msg[i],SizeOf(Msg[i]));
    f.Free;
  except
    Result:=1;
  end;
end;

function ReadFromFile(FileName: string): string; stdcall;
var
f: TFileStream;
MsgSize, Offset, i: LongWord;
str: string;
c: char;
begin
  Result:='';
  try
    str:='';
    f:=TFileStream.Create(FileName,fmOpenReadWrite);
    f.Seek(6,0);
    f.Read(MsgSize,SizeOf(MsgSize));
    f.Read(Offset,SizeOf(OffSet));
    f.Seek(Offset,0);
    for i:=1 to MsgSize do
    begin
      f.Read(c,SizeOf(c));
      str:=str+c;
    end;
    f.Free;
    ReadFromFile:=str;
  except
    Result:='Unknown error';
  end;
end;

exports
  SaveToFile name 'SaveToFile',
  ReadFromFile name 'ReadFromFile';

begin
end.
