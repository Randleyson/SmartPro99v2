unit View.Frame.Pesquisa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, FMX.Layouts, FMX.Objects,
  FMX.Effects, FMX.Filter.Effects;

type
  TFramePesquisa = class(TFrame)
    RectPesquisaProduto: TRectangle;
    CBoxFiltro: TComboBox;
    EdtPesquisa: TEdit;
    Image1: TImage;
    Rectangle1: TRectangle;
    FillRGBEffect1: TFillRGBEffect;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFramePesquisa }


end.
