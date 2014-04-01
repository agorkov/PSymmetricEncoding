unit UErrors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFErrors = class(TForm)
    Memo1: TMemo;
    BBExit: TBitBtn;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FErrors: TFErrors;

implementation

{$R *.dfm}
uses
  UMain;

procedure TFErrors.Button1Click(Sender: TObject);
var
f: TextFile;
begin
  try
    AssignFile(f,Edit1.Text+DateToStr(Date)+'.txt');
    ReWrite(f);
    CloseFile(f);
  except
  end;
  UMain.Errors.SaveToFile(Edit1.Text+DateToStr(Date)+'.txt');
end;

procedure TFErrors.FormShow(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Edit1.Text:=UMain.FMain.DirectoryListBox1.Directory+'\Crypt';
  Memo1.Lines:=UMain.Errors;
  Memo1.Lines.Add(TimeToStr(Time));
end;

end.
