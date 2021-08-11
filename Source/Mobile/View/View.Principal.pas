unit View.Principal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  View.TabelaPreco,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Objects,
  View.Configuracao;

type
  TFrmPrincipal = class(TForm)
    TmSplash: TTimer;
    Layout1: TLayout;
    Label1: TLabel;
    Rectangle1: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure TmSplashTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    const cVersao: String = '3.0.0';
  public
    { Public declarations }
    FrameTabelaPreco: TViewTabelaPreco;
    FrameConfiguracao: TViewConfiguracoes;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  uDm;

{$R *.fmx}

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin

  if Assigned(FrameTabelaPreco) then
    FrameTabelaPreco.DisposeOf;

  if Assigned(FrameConfiguracao) then
    FrameConfiguracao.DisposeOf;

  if Assigned(Dm) then
    Dm.DisposeOf;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  TmSplash.Interval := 1500;
  TmSplash.Enabled  := True;
end;

procedure TFrmPrincipal.TmSplashTimer(Sender: TObject);
begin

  TmSplash.Enabled  := False;
  Dm                := TDm.Create(Nil);
  Dm.LerConfiguracao;
  FrameTabelaPreco  := TViewTabelaPreco.Create(Nil);
  FrameTabelaPreco.ShowView;

end;

end.
