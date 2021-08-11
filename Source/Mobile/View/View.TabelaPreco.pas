unit View.TabelaPreco;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  uDm,
  View.Frames.TabelaCores,
  View.Configuracao,
  System.ImageList,
  FMX.ImgList;

type
  TViewTabelaPreco = class(TFrame)
    RectClient: TRectangle;
    RectTitulo: TRectangle;
    RectRodaPe: TRectangle;
    ImgConfiguracoes: TImage;
    ImgConexao: TImage;
    FrameTabelaCores1: TFrameTabelaCores;
    Label1: TLabel;
    Label2: TLabel;
    LstProdutos: TListBox;
    LblSemRegistro: TLabel;
    Image1: TImage;
    LytImagen: TLayout;
    TmProxino: TTimer;
    procedure ImgConfiguracoesClick(Sender: TObject);
    procedure TmProxinoTimer(Sender: TObject);
  private
    { Private declarations }
    procedure ListarProdutos;
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure ShowView;
  end;

implementation

uses
  View.Frames.ItemLista,
  View.Principal;

{$R *.fmx}
{ TViewTabelaPreco }

constructor TViewTabelaPreco.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TViewTabelaPreco.Destroy;
begin
  inherited;
end;

procedure TViewTabelaPreco.ImgConfiguracoesClick(Sender: TObject);
begin
  TmProxino.Enabled := False;
  if not Assigned(FrmPrincipal.FrameConfiguracao) then
    FrmPrincipal.FrameConfiguracao := TViewConfiguracoes.Create(Nil);
  FrmPrincipal.FrameConfiguracao.ShowView;
  FrmPrincipal.FrameTabelaPreco.Visible := False;
end;

procedure TViewTabelaPreco.ListarProdutos;
var
  vFrame: TFrameItemList;
  vListBoxItem: TListBoxItem;
  i: Integer;
begin
  i := 0;
  LblSemRegistro.Visible  := True;
  LstProdutos.BeginUpdate;
  try
    LstProdutos.Items.Clear;
    while not dm.DS_Produtos.Eof do
    begin
      LblSemRegistro.Visible  := False;

      vListBoxItem            := TListBoxItem.Create(LstProdutos);
      vListBoxItem.Height     := 50;
      vListBoxItem.TagString  := Dm.FMenProduto.FieldByName('codbarra').AsString;

      vFrame        := TFrameItemList.Create(Nil);
      vFrame.Parent := vListBoxItem;
      vFrame.Align  := Align.alClient;
      vFrame.LblDescricao.Text  := dm.DS_Produtos.FieldByName('descricao').AsString;
      vFrame.LblValor.Text      := Formatfloat('##,###,##0.00', dm.DS_Produtos.FieldByName('vrvenda').AsCurrency);
      vFrame.LblUnd.Text        := dm.DS_Produtos.FieldByName('unidade').AsString;

      i := i + 1;
      vFrame.CorFundo(i mod 2);
      LstProdutos.AddObject(vListBoxItem);
      if i = Dm.QtdeProduto then Exit;
      Dm.DS_Produtos.Next;

      // Se for o ultimo registro, faz um sicronização com o servidor;
      if dm.DS_Produtos.Eof then
      begin
        TThread.CreateAnonymousThread(
        procedure
        begin
          try
            TmProxino.Enabled := False;
            Dm.ReloandProdutos;
          finally

          TThread.Synchronize(nil,
            procedure
            begin
              Dm.DS_Produtos.First;
              TmProxino.Enabled := True;
            end);
          end;
        end).Start;
      end;
    end;


  finally
    LstProdutos.EndUpdate;
  end;

end;

procedure TViewTabelaPreco.ShowView;
begin

  Parent                    := FrmPrincipal;
  FrameTabelaCores1.Visible := False;
  Visible                   := True;
  TmProxino.Interval        := Dm.Time;
  TmProxino.Enabled         := True;
  LytImagen.Width           := Dm.WidthLayoutImagen;

  Application.ProcessMessages;
  Dm.ReloandProdutos;
  Dm.DS_Produtos.First;
  ListarProdutos;
  BringToFront;

end;

procedure TViewTabelaPreco.TmProxinoTimer(Sender: TObject);
begin
  if not Assigned(FrmPrincipal.FrameConfiguracao) then
    ListarProdutos;
end;

end.
