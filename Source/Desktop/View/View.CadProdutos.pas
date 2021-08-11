unit View.CadProdutos;

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
  View.Frame.Cabecalho,
  FMX.Objects,
  FMX.Edit,
  View.Frame.Pesquisa,
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
  FireDAC.Comp.Client, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

type
  TFrameCadProdutos = class(TFrame)
    Layout1: TLayout;
    LytListaProdutos: TLayout;
    Label1: TLabel;
    FramePesquisa: TFramePesquisa;
    LytCadProduto: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    LytCodBarra: TLayout;
    Label7: TLabel;
    EdtCodBarra: TEdit;
    LytDescricao: TLayout;
    Label6: TLabel;
    EdtDecricao: TEdit;
    Label10: TLabel;
    LytUnidade: TLayout;
    Label8: TLabel;
    EdtUnidade: TEdit;
    LytVrVenda: TLayout;
    Label9: TLabel;
    EdtVrVenda: TEdit;
    Rectangle1: TRectangle;
    FrameCabecalho1: TFrameCabecalho;
    GrdProduto: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FrameCabecalho1ImgFecharClick(Sender: TObject);
    procedure GrdProdutoCellClick(const Column: TColumn; const Row: Integer);
    procedure FramePesquisaEdtPesquisaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    procedure ListaProdutos;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CloseCadProduto;
  end;
var
  FrameCadProdutos: TFrameCadProdutos;

implementation

uses
  uDm;

{$R *.fmx}

{ TFrameCadProdutos }

constructor TFrameCadProdutos.Create(AOwner: TComponent);
begin
  inherited;
  FrameCabecalho1.LblNomeDaTela.Text := 'Cadastro de Produtos';

  FramePesquisa.CBoxFiltro.Items.Clear;
  FramePesquisa.CBoxFiltro.Items.Add('CODIGO BARRA');
  FramePesquisa.CBoxFiltro.Items.Add('DESCRIÇÃO');
  FramePesquisa.CBoxFiltro.Items.Add('UNIDADE');
  FramePesquisa.CBoxFiltro.Items.Add('VALOR VENDA');
  FramePesquisa.CBoxFiltro.ItemIndex := 1;

  EdtCodBarra.Enabled := False;
  EdtDecricao.Enabled := False;
  EdtUnidade.Enabled  := False;
  EdtVrVenda.Enabled  := False;

  ListaProdutos;
end;


procedure TFrameCadProdutos.CloseCadProduto;
begin
  if Assigned(FrameCadProdutos) then
  begin
    FrameCadProdutos.Visible := False;
    FrameCadProdutos.DisposeOf;
    FrameCadProdutos := Nil;
  end;
end;

procedure TFrameCadProdutos.FrameCabecalho1ImgFecharClick(Sender: TObject);
begin
  CloseCadProduto;
end;

procedure TFrameCadProdutos.GrdProdutoCellClick(const Column: TColumn; const Row: Integer);
begin
  EdtCodBarra.Text  := GrdProduto.Cells[0,Row];
  EdtDecricao.Text  := GrdProduto.Cells[1,Row];
  EdtUnidade.Text   := GrdProduto.Cells[2,Row];
  EdtVrVenda.Text   := GrdProduto.Cells[3,Row];
end;

procedure TFrameCadProdutos.ListaProdutos;
begin

  Dm.LerDSProdutos;
  GrdProduto.Columns[0].Header := 'Cod Barra';
  GrdProduto.Columns[0].Width  := 70;

  GrdProduto.Columns[1].Header := 'Descrição';
  GrdProduto.Columns[1].Width  := 200;

  GrdProduto.Columns[2].Header := 'Vr Venda';
  GrdProduto.Columns[2].Width  := 60;

  GrdProduto.Columns[3].Header := 'Und';
  GrdProduto.Columns[3].Width  := 40;
end;

procedure TFrameCadProdutos.FramePesquisaEdtPesquisaKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  vValue, vFiltro: String;
begin

  vValue := UpperCase('%' + FramePesquisa.EdtPesquisa.Text + '%');
  if Key = 120 then Exit;
  case FramePesquisa.CBoxFiltro.ItemIndex of
  0:
    vFiltro := 'CODBARRA';
  1:
    vFiltro := 'DESCRICAO';
  2:
    vFiltro := 'UNIDADE';
  3:
    vFiltro := 'VRVENDA';
  end;

  Dm.DS_Produtos.Filtered  := False;
  Dm.DS_Produtos.Filter    := vFiltro + ' Like ' + QuotedStr(vValue);
  Dm.DS_Produtos.Filtered  := True;

end;

end.
