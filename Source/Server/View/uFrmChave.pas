unit uFrmChave;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmChave = class(TForm)
    Label1: TLabel;
    EdtChave: TEdit;
    BtnRegistar: TRectangle;
    BtnSair: TRectangle;
    Label2: TLabel;
    Label3: TLabel;
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmChave: TFrmChave;

implementation

{$R *.fmx}

end.
