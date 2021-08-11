unit View.FrmPrincipal;

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
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Menus,
  FMX.Layouts, FMX.Effects, FMX.Filter.Effects, FMX.Edit;

type
  TViewFrmPrincipal = class(TForm)
    RectMan: TRectangle;
    LytFrame: TLayout;
    RectTop: TRectangle;
    RectMenu: TRectangle;
    Layout2: TLayout;
    ImgConfiguracao: TImage;
    FillRGBEffect3: TFillRGBEffect;
    RectProdutos: TRectangle;
    Image5: TImage;
    FillRGBEffect1: TFillRGBEffect;
    Label5: TLabel;
    RectAtivoMenuProd: TRectangle;
    RectTvs: TRectangle;
    Image6: TImage;
    FillRGBEffect2: TFillRGBEffect;
    Label6: TLabel;
    RectAtivoMenuTv: TRectangle;
    LblVersao: TLabel;
    Label1: TLabel;
    rectAcessoBloqueado: TRectangle;
    edtNovaKey: TEdit;
    Label2: TLabel;
    rectRegistar: TRectangle;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle2: TRectangle;
    rectAcessoLiberado: TRectangle;
    FillRGBEffect4: TFillRGBEffect;
    Line1: TLine;
    Line2: TLine;
    procedure FormShow(Sender: TObject);
    procedure ImgConfiguracaoClick(Sender: TObject);
    procedure RectTvsClick(Sender: TObject);
    procedure RectProdutosClick(Sender: TObject);
    procedure RectTvsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure RectTvsMouseLeave(Sender: TObject);
    procedure RectProdutosMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure RectProdutosMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure rectRegistarClick(Sender: TObject);
  private
    { Private declarations }
    const cVersao: String = '3.1.0';
    procedure FinalizaFrames;
    procedure AcessoBloqueado;
    procedure AcessoLiberado;
  public
    { Public declarations }
  end;

var
  ViewFrmPrincipal: TViewFrmPrincipal;

implementation

{$R *.fmx}

uses  View.CadProdutos,
      View.Configuracao,
      View.CadTVs,
      View.Mensagem,
      uDm,
      uSmartPro99,
      uAccessKey;


procedure TViewFrmPrincipal.AcessoBloqueado;
begin

  rectAcessoBloqueado.Visible := True;
  rectAcessoBloqueado.BringToFront;

end;

procedure TViewFrmPrincipal.AcessoLiberado;
begin

  rectAcessoBloqueado.Visible := False;
  rectAcessoLiberado.BringToFront;

end;

procedure TViewFrmPrincipal.FinalizaFrames;
begin

  if Assigned(FrameCadProdutos) then
    FrameCadProdutos.CloseCadProduto;
  if Assigned(FrameConfiguracao) then
    FrameConfiguracao.CloseConfiguracao;
  if Assigned(FrameCadTVs) then
    FrameCadTVs.CloseCadTVs;

  RectAtivoMenuProd.Fill.Kind := TBrushKind(0);
  RectAtivoMenuTv.Fill.Kind   := TBrushKind(0);

end;

procedure TViewFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FinalizaFrames;
end;


procedure TViewFrmPrincipal.FormDestroy(Sender: TObject);
begin
  rectAcessoBloqueado.DisposeOf;
  SmartPro.DisposeOf;
end;

procedure TViewFrmPrincipal.FormShow(Sender: TObject);
begin

  SmartPro := TSmartPro.Create;
  LblVersao.Text := 'Versão: ' + cVersao;

  // Menu
  RectTvs.Fill.Kind           := TBrushKind(0);
  RectProdutos.Fill.Kind      := TBrushKind(0);
  RectAtivoMenuProd.Fill.Kind := TBrushKind(0);
  RectAtivoMenuTv.Fill.Kind   := TBrushKind(0);

  // Validacao da Chave
  AcessoBloqueado;
  if TAccessKey.ValidaKey(Dm.LerKeyAccess) then
    AcessoLiberado;

end;

procedure TViewFrmPrincipal.ImgConfiguracaoClick(Sender: TObject);
begin

  FinalizaFrames;
  if not Assigned(FrameConfiguracao) then
    FrameConfiguracao       := TFrameConfiguracao.Create(Nil);

  FrameConfiguracao.Parent  := LytFrame;
  FrameConfiguracao.BringToFront;

end;

procedure TViewFrmPrincipal.rectRegistarClick(Sender: TObject);
var
  vKey: String;
begin

  vKey := edtNovaKey.Text;

  if not TAccessKey.ValidaKey(vKey) then
    raise Exception.Create('Nova chave nao é valida');

  Dm.InseriNovaKeyAcesso(vKey);
  AcessoLiberado;

end;

procedure TViewFrmPrincipal.RectProdutosClick(Sender: TObject);
begin

  FinalizaFrames;
  if not Assigned(FrameCadProdutos) then
    FrameCadProdutos      := TFrameCadProdutos.Create(Nil);

  RectAtivoMenuProd.Fill.Kind := TBrushKind(1);
  FrameCadProdutos.Parent := LytFrame;
  FrameCadProdutos.BringToFront;

end;

procedure TViewFrmPrincipal.RectProdutosMouseLeave(Sender: TObject);
begin
  RectProdutos.Fill.Kind := TBrushKind(0);
end;

procedure TViewFrmPrincipal.RectProdutosMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  RectProdutos.Fill.Kind := TBrushKind(1);
end;

procedure TViewFrmPrincipal.RectTvsClick(Sender: TObject);
begin
  FinalizaFrames;
  if not Assigned(FrameCadTVs) then
    FrameCadTVs       := TFrameCadTVs.Create(Nil);

  RectAtivoMenuTv.Fill.Kind := TBrushKind(1);
  FrameCadTVs.Parent        := LytFrame;
  FrameCadTVs.BringToFront;

end;

procedure TViewFrmPrincipal.RectTvsMouseLeave(Sender: TObject);
begin
  RectTvs.Fill.Kind := TBrushKind(0);
end;

procedure TViewFrmPrincipal.RectTvsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  RectTvs.Fill.Kind := TBrushKind(1);
end;

end.
