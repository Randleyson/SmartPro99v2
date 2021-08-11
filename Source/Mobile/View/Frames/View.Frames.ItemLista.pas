unit View.Frames.ItemLista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  TFrameItemList = class(TFrame)
    Rectangle1: TRectangle;
    LblDescricao: TLabel;
    LblUnd: TLabel;
    LblValor: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CorFundo( aParant: Integer);
  end;

implementation

{$R *.fmx}

{ TFrameItemList }

procedure TFrameItemList.CorFundo( aParant: Integer);
begin
  if aParant = 0 then
    Rectangle1.Fill.Color := $FFFEFE00
  else
    Rectangle1.Fill.Color := $7DFEFE00;
end;

end.
