unit View.CadTVs;

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
  FMX.Edit,
  View.Frame.Pesquisa,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Objects,
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
  System.Rtti,
  FMX.Grid.Style,
  FMX.ScrollBox,
  FMX.Grid,
  Data.Bind.EngExt,
  Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid,
  System.Bindings.Outputs,
  Fmx.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  Datasnap.DBClient,
  FMX.Effects,
  FMX.Filter.Effects,
  uSmartPro99;


type
  TFrameCadTVs = class(TFrame)
    Rectangle1: TRectangle;
    LytCadTv: TLayout;
    LytProdTv: TLayout;
    Label5: TLabel;
    LytProdutoNotTV: TLayout;
    LstProdutosNotTV: TListBox;
    LblSemRegProdutosNotTV: TLabel;
    FramePesqProdutosNotTV: TFramePesquisa;
    LytProdutosCadTv: TLayout;
    LstProdutosCadTV: TListBox;
    LblSemRegProdutosCadTV: TLabel;
    FramePesqProdutosCadTV: TFramePesquisa;
    LytBotao: TLayout;
    BtnAdicionarProdTv: TRectangle;
    BtnRemoverTodos: TRectangle;
    BtnAdicionarTodos: TRectangle;
    LytDetalhesTv: TLayout;
    Layout6: TLayout;
    Label3: TLabel;
    Layout7: TLayout;
    Label4: TLabel;
    EdtDescricaoTv: TEdit;
    LytListaTv: TLayout;
    Label1: TLabel;
    LstBoxTvs: TListBox;
    LblSemRegTVs: TLabel;
    FramePesquisaTvs: TFramePesquisa;
    FrameCabecalho1: TFrameCabecalho;
    ToolBarBotao: TToolBar;
    BtnAdicionar: TRectangle;
    Label10: TLabel;
    BtnCancelar: TRectangle;
    Label11: TLabel;
    BtnExcluir: TRectangle;
    Label12: TLabel;
    BtnGravar: TRectangle;
    Label14: TLabel;
    BtnEditar: TRectangle;
    Label13: TLabel;
    LblCodTv: TLabel;
    Line1: TLine;
    GridTv: TStringGrid;
    GridProdutoNotTV: TStringGrid;
    GridProdutosCadTV: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    BindSourceDB3: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB3: TLinkGridToDataSource;
    Image1: TImage;
    BtnRemoverProdTv: TRectangle;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    FillRGBEffect1: TFillRGBEffect;
    FillRGBEffect2: TFillRGBEffect;
    FillRGBEffect3: TFillRGBEffect;
    FillRGBEffect4: TFillRGBEffect;
    procedure LstBoxTvsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure BtnAdicionarProdTvClick(Sender: TObject);
    procedure BtnAdicionarTodosClick(Sender: TObject);
    procedure BtnRemoverTodosClick(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FrameCabecalho1ImgFecharClick(Sender: TObject);
    procedure FramePesqProdutosNotTVEdtPesquisaKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FramePesqProdutosCadTVEdtPesquisaKeyUp(Sender: TObject;  var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FramePesquisaTvsEdtPesquisaKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure GridTvCellClick(const Column: TColumn; const Row: Integer);
    procedure BtnRemoverProdTvClick(Sender: TObject);

  private
    procedure DetalharTv;
    procedure EnabledBtn(pBtnAdicionar, pEdita, pGravar, pExcluir, pCancelar: Boolean);
    procedure LimpaEditPesquisa;
    procedure ListarGridTVs;
    procedure ListarProtNotTv;
    procedure ListarProdCadTv;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseCadTVs;
  end;
var
  FrameCadTVs: TFrameCadTVs;

implementation

uses
  uDm,
  FMX.DialogService;

{$R *.fmx}

{ TFrameCadTVs }

procedure TFrameCadTVs.BtnAdicionarClick(Sender: TObject);
begin

  SmartPro.Tvs.StatusTela := tsAdicionar;
  SmartPro.Tvs.IdTV             := 0;
  LblCodTv.Text       := '';
  EdtDescricaoTv.Text := '';

  LytCadTv.Enabled    := True;
  LytListaTv.Enabled  := False;

  ListarProtNotTv;
  ListarProdCadTv;

  EnabledBtn(False,False,True,False,True);
  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.BtnAdicionarProdTvClick(Sender: TObject);
begin

  if GridProdutoNotTV.Row < 0 then
  begin
    ShowMessage('Produtos nao selecionado');
    Exit;
  end;

  dm.DS_ProdNotTv.Filtered  := False;
  dm.DS_ProdNotTv.Filter    := 'CodBarra = ' + QuotedStr(GridProdutoNotTV.Cells[0,GridProdutoNotTV.Row]);
  dm.DS_ProdNotTv.Filtered  := True;

  dm.DS_ProdCadTv.Append;
  dm.DS_ProdCadTv.CopyRecord(dm.DS_ProdNotTv);
  dm.DS_ProdCadTv.Post;

  dm.DS_ProdNotTv.Delete;
  dm.DS_ProdNotTv.Filtered  := False;
  dm.DS_ProdCadTv.Filtered  := False;

  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.BtnAdicionarTodosClick(Sender: TObject);
begin

  if LstProdutosNotTV.Count >= 0 then
  begin
    Dm.DS_ProdNotTv.Filtered  := False;
    Dm.DS_ProdNotTv.First;

    Dm.DS_ProdCadTv.CopyDataSet(Dm.DS_ProdNotTv);
    Dm.DS_ProdNotTv.EmptyDataSet;

  end;
  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.BtnCancelarClick(Sender: TObject);
begin
  LytCadTv.Enabled    := False;
  LytListaTv.Enabled  := True;
  ListarGridTVs;
  EnabledBtn(True,True,False,True,False);
  LimpaEditPesquisa;
end;


procedure TFrameCadTVs.BtnEditarClick(Sender: TObject);
begin
  SmartPro.Tvs.StatusTela := tsEditar;
  LytCadTv.Enabled        := True;
  LytListaTv.Enabled      := False;
  EnabledBtn(False,False,True,False,True);
  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.BtnExcluirClick(Sender: TObject);
begin

  TDialogService.MessageDialog('Deseja realmente excluir a Tv?',
    TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin

      if AResult = mrYes then
      begin
        Dm.ExcluirTv(SmartPro.Tvs.IdTV);
        ListarGridTVs;
        LytCadTv.Enabled   := False;
        LytListaTv.Enabled := True;
        EnabledBtn(True,True,False,True,False);
        LimpaEditPesquisa;

      end;
    end);

end;

procedure TFrameCadTVs.FrameCabecalho1ImgFecharClick(Sender: TObject);
begin
  CloseCadTVs;
end;

procedure TFrameCadTVs.FramePesqProdutosCadTVEdtPesquisaKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  vFilter: String;
  vParant: String;
begin
  if Key = 120 then Exit;
  vFilter := UpperCase('%' + FramePesquisaTvs.EdtPesquisa.Text + '%');
  case FramePesqProdutosCadTV.CBoxFiltro.ItemIndex of
    0:
      vParant := 'CODBARRA';
    1:
      vParant := 'DESCRICAO';
  end;

 Dm.DS_ProdCadTv.Filtered  := False;
 Dm.DS_ProdCadTv.Filter    := vParant + ' Like ' + QuotedStr(vFilter);
 Dm.DS_ProdCadTv.Filtered  := True;

end;

procedure TFrameCadTVs.FramePesqProdutosNotTVEdtPesquisaKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  vFilter: String;
  vParant: String;
begin
  if Key = 120 then Exit;

  vFilter := UpperCase('%' + FramePesqProdutosNotTV.EdtPesquisa.Text + '%');
  case FramePesqProdutosNotTV.CBoxFiltro.ItemIndex of
    0:
      vParant := 'CODBARRA';
    1:
      vParant := 'DESCRICAO';
  end;

  Dm.DS_ProdNotTv.Filtered := False;
  Dm.DS_ProdNotTv.Filter   := vParant + ' Like ' + QuotedStr(vFilter);
  Dm.DS_ProdNotTv.Filtered := True;

end;

procedure TFrameCadTVs.FramePesquisaTvsEdtPesquisaKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  vFilter: String;
  vParant: String;
begin

  if Key = 120 then Exit;

  vFilter := UpperCase('%' + FramePesquisaTvs.EdtPesquisa.Text + '%');
  case FramePesquisaTvs.CBoxFiltro.ItemIndex of
    0:
      vParant := 'IDTV';
    1:
      vParant := 'DESCRICAO';
  end;

  Dm.DS_Tv.Filtered := False;
  Dm.DS_Tv.Filter   := vParant + ' Like ' + QuotedStr(vFilter);
  Dm.DS_Tv.Filtered := True;

end;

procedure TFrameCadTVs.GridTvCellClick(const Column: TColumn;
  const Row: Integer);
begin
  EnabledBtn(True,True,False,True,False);
  DetalharTv;
end;

procedure TFrameCadTVs.BtnGravarClick(Sender: TObject);
begin

  SmartPro.Tvs.NomeTV := EdtDescricaoTv.Text;

  case SmartPro.Tvs.StatusTela of
  tsAdicionar  :
    Dm.InsertTv(SmartPro.Tvs.NomeTV);
  tsEditar     :
    Dm.UpdateTv(SmartPro.Tvs.IdTV,SmartPro.Tvs.NomeTV);
  end;

  ListarGridTVs;
  LytCadTv.Enabled    := False;
  LytListaTv.Enabled  := True;
  ShowMessage('Registro gravado com exito');
  EnabledBtn(True,True,False,True,False);
  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.CloseCadTVs;
begin
  if Assigned(FrameCadTVs) then
  begin
    FrameCadTVs.Visible := False;
    FrameCadTVs.DisposeOf;
    FrameCadTVs := Nil;
  end;
end;


procedure TFrameCadTVs.BtnRemoverProdTvClick(Sender: TObject);
begin

  if LstProdutosCadTV.count < 0 then
  begin
    ShowMessage('Não a produto para ser removido da Tv');
    Exit;
  end;

  Dm.DS_ProdCadTv.Filtered  := False;
  Dm.DS_ProdCadTv.Filter    := 'CodBarra = ' + QuotedStr(GridProdutosCadTV.Cells[0,GridProdutosCadTV.Row]);
  Dm.DS_ProdCadTv.Filtered  := True;
  Dm.DS_ProdCadTv.First;

  Dm.DS_ProdNotTv.Append;
  Dm.DS_ProdNotTv.CopyRecord(dm.DS_ProdCadTv);
  Dm.DS_ProdNotTv.Post;

  dm.DS_ProdCadTv.Delete;
  dm.DS_ProdCadTv.Filtered := False;
  LimpaEditPesquisa;
end;

procedure TFrameCadTVs.BtnRemoverTodosClick(Sender: TObject);
begin
  if LstProdutosCadTV.count >= 0 then
  begin
    Dm.DS_ProdCadTv.Filtered  := False;
    Dm.DS_ProdCadTv.First;

    Dm.DS_ProdNotTv.CopyDataSet(Dm.DS_ProdCadTv);

    Dm.DS_ProdCadTv.EmptyDataSet;

  end;
  LimpaEditPesquisa;
end;


constructor TFrameCadTVs.Create(AOwner: TComponent);
begin
  inherited;

  FrameCabecalho1.LblNomeDaTela.Text  := 'TVs';
  LytCadTv.Enabled                    := False;

  FramePesquisaTvs.CBoxFiltro.Clear;
  FramePesquisaTvs.CBoxFiltro.Items.Add('Codigo Tv');
  FramePesquisaTvs.CBoxFiltro.Items.Add('Descrição');
  FramePesquisaTvs.CBoxFiltro.ItemIndex := 1;

  FramePesqProdutosNotTV.CBoxFiltro.Clear;
  FramePesqProdutosNotTV.CBoxFiltro.Items.Add('Codigo Barra');
  FramePesqProdutosNotTV.CBoxFiltro.Items.Add('Descrição');
  FramePesqProdutosNotTV.CBoxFiltro.ItemIndex := 1;

  FramePesqProdutosCadTV.CBoxFiltro.Clear;
  FramePesqProdutosCadTV.CBoxFiltro.Items.Add('Codigo Barra');
  FramePesqProdutosCadTV.CBoxFiltro.Items.Add('Descrição');
  FramePesqProdutosCadTV.CBoxFiltro.ItemIndex := 1;
  ListarGridTVs;
end;

destructor TFrameCadTVs.Destroy;
begin

  inherited;
end;

procedure TFrameCadTVs.DetalharTv;
begin
  SmartPro.Tvs.IdTv             := StrToInt(GridTv.Cells[0,GridTv.Row]);
  LblCodTv.Text       := IntToStr(SmartPro.Tvs.IdTv);
  EdtDescricaoTv.Text := GridTv.Cells[1,GridTv.Row];

  Dm.LerDSProdNotTv(SmartPro.Tvs.IdTV);
  Dm.LerDSProdCadTv(SmartPro.Tvs.IdTV);

end;

procedure TFrameCadTVs.EnabledBtn(pBtnAdicionar, pEdita, pGravar, pExcluir, pCancelar: Boolean);
begin
  BtnAdicionar.Enabled  := pBtnAdicionar;
  BtnEditar.Enabled     := pEdita;
  BtnGravar.Enabled     := pGravar;
  BtnExcluir.Enabled    := pExcluir;
  BtnCancelar.Enabled   := pCancelar;
end;

procedure TFrameCadTVs.LstBoxTvsItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  SmartPro.Tvs.IdTV := StrToInt(Item.TagString);
  DetalharTv;
end;

procedure TFrameCadTVs.LimpaEditPesquisa;
begin
  FramePesqProdutosNotTV.EdtPesquisa.Text := '';
  FramePesqProdutosCadTV.EdtPesquisa.Text := '';
  FramePesquisaTvs.EdtPesquisa.Text       := '';
end;

procedure TFrameCadTVs.ListarGridTVs;
begin
  dm.LerDSTv;
  LblSemRegTVs.Visible := True;

  GridTv.Columns[0].Header := 'Codigo';
  GridTv.Columns[0].Width  := 60;

  GridTv.Columns[1].Header := 'Descrição';
  GridTv.Columns[1].Width  := 220;

  DetalharTv;
end;

procedure TFrameCadTVs.ListarProdCadTv;
begin
  Dm.LerDSProdCadTv(SmartPro.Tvs.IdTv);
  GridProdutosCadTV.Columns[0].Header := 'Cod Barra';
  GridProdutosCadTV.Columns[0].Width  := 70;

  GridProdutosCadTV.Columns[1].Header := 'Descrição';
  GridProdutosCadTV.Columns[1].Width  := 200;

  GridProdutosCadTV.Columns[2].Header := 'Vr Venda';
  GridProdutosCadTV.Columns[2].Width  := 60;

  GridProdutosCadTV.Columns[3].Header := 'Und';
  GridProdutosCadTV.Columns[3].Width  := 40;
end;

procedure TFrameCadTVs.ListarProtNotTv;
begin

  Dm.LerDSProdNotTv(SmartPro.Tvs.IdTv);

  GridProdutoNotTV.Columns[0].Header := 'Cod Barra';
  GridProdutoNotTV.Columns[0].Width  := 70;

  GridProdutoNotTV.Columns[1].Header := 'Descrição';
  GridProdutoNotTV.Columns[1].Width  := 200;

  GridProdutoNotTV.Columns[2].Header := 'Vr Venda';
  GridProdutoNotTV.Columns[2].Width  := 60;

  GridProdutoNotTV.Columns[3].Header := 'Und';
  GridProdutoNotTV.Columns[3].Width  := 40;
end;

end.
