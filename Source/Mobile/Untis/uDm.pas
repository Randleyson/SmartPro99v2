unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.JSON, uRestDataWare, uFiredac
  {$IFDEF ANDROID}
  ,System.IOUtils
  {$ENDIF};

type
  TDm = class(TDataModule)
    FMenProduto: TFDMemTable;
    FMenTvs: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    uRestDataWare: TRestDataWare;
    uFireDAC: TFiredac;
    FJOSNArray: TJSONArray;
    FHostServer: String;
    FTime: Integer;
    FQtdeProdutos: Integer;
    FWidthLayoutImagen: Integer;
    procedure ConfigurarConexaoBanco;
  public
    { Public declarations }
    FIdTv: Integer;
    function Conexao: Boolean;
    function DS_Produtos: TFDMemTable;
    function DS_Tvs: TFDMemTable;
    function GravarTv: TDm;
    function GravarServer: TDm;
    function HostServer: String; overload;
    function HostServer( aValue: String): TDm; overload;
    procedure ReloandProdutos;
    procedure ReloandTv;
    function Time( aValue: Integer): TDm; overload;
    function Time: Integer; overload;
    function QtdeProduto( aValue: Integer): TDm; overload;
    function QtdeProduto: Integer; overload;
    function WidthLayoutImagen( aValue: Integer): TDm; overload;
    function WidthLayoutImagen: Integer; overload;
    function LerConfiguracao: Boolean;
  end;

var
  Dm: TDm;

implementation

uses
  FMX.Dialogs, Vcl.Forms;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDm }

function TDm.Conexao: Boolean;
begin
  Result := uRestDataWare.Conexao;
end;

procedure TDm.ConfigurarConexaoBanco;
begin

  uFireDAC.DriverID := 'SQLite';
  {$IFDEF ANDROID}
  uFiredac.Database := TPath.Combine(TPath.GetDocumentsPath, 'Mobile3.db');
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  uFireDAC.Database := 'D:\Projetos\SmartPro99\trunk\Db\Mobile3.db';
  {$ENDIF}
  uFireDAC.AbreConexaoBanco(True);

end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin

  uFireDAC  := TFiredac.New;
  ConfigurarConexaoBanco;
  uRestDataWare := TRestDataWare.Create;

end;

procedure TDm.DataModuleDestroy(Sender: TObject);
begin
  uRestDataWare.DisposeOf;
  uFiredac.DisposeOf;
end;

function TDm.GravarServer: TDm;
begin
  Result := Self;
  uFiredac
    .Active(False)
      .SQLClear
      .SQL('update tab_configuracoes set hostServer = :HOSTSERVER')
      .AddParan('HOSTSERVER',FHostServer)
    .ExceSQL;
end;

function TDm.GravarTv: TDm;
begin
  Result := Self;
  uFiredac
    .Active(False)
    .SQLClear
      .SQL('update tab_configuracoes set idtv = :IDTV, Time = :TIME,')
      .SQL('QtdeProdutos = :QTDEPRODUTOS, WidthLayoutImagen = :WIDTHLAYOUTIMAGEN')
      .AddParan('IDTV', FIdTv)
      .AddParan('TIME', FTime)
      .AddParan('QTDEPRODUTOS',FQtdeProdutos)
      .AddParan('WIDTHLAYOUTIMAGEN',FWidthLayoutImagen)
    .ExceSQL;
end;

function TDm.HostServer(aValue: String): TDm;
begin
  Result := Self;
  FHostServer := aValue;
end;

function TDm.LerConfiguracao: Boolean;
var
  vDataSet: TDataSet;
begin

  Result := False;
  try

    vDataSet := uFireDAC
                  .Active(False)
                  .SQLClear
                  .SQL(' select idtv, hostserver, Time, QtdeProdutos, WidthLayoutImagen')
                  .SQL(' from tab_configuracoes')
                .Open
               .DataSet;

    try
      FHostServer         := vDataSet.FieldByName('hostserver').AsString;
      FIdTV               := vDataSet.FieldByName('Idtv').AsInteger;
      FTime               := vDataSet.FieldByName('Time').AsInteger;
      FQtdeProdutos       := vDataSet.FieldByName('QtdeProdutos').AsInteger;
      FWidthLayoutImagen  := vDataSet.FieldByName('WidthLayoutImagen').AsInteger;
      uRestDataWare.HostServer(FHostServer);
      Result              := True;

    finally
      uFiredac.Active(False);

    end;

  except
    raise Exception.Create('Erro ao ler os paramentros de configuração');
  end;

end;

function TDm.QtdeProduto: Integer;
begin
  Result := FQtdeProdutos;
end;

function TDm.QtdeProduto(aValue: Integer): TDm;
begin
  Result := Self;
  FQtdeProdutos := aValue;
end;

function TDm.HostServer: String;
begin
  Result := FHostServer;
end;

function TDm.DS_Produtos: TFDMemTable;
begin
  Result := FMenProduto;
end;

function TDm.DS_TVs: TFDMemTable;
begin
  Result := FMenTvs;
end;

procedure TDm.ReloandProdutos;
var
  i: Integer;
begin

  //Receber Produtos Server
  FJOSNArray := Nil;
  FJOSNArray := uRestDataWare
                  .Resource('ProdutosTv')
                  .ClearParans
                    .AddParameter('Idtv',FIdTv)
                  .Execute
                .JSONArray;

  if uRestDataWare.StatusCode = 200 then
  begin

    //Insert no banco Local
    try

      uFiredac
        .Active(False)
        .SQLClear.SQL('update tab_produtos set ie = ''E''')
      .ExceSQL;

      try
        for I := 0 to (FJOSNArray.Size - 1) do
        begin
          uFiredac
            .Active(False)
              .SQLClear
              .SQL('Insert Into tab_produtos (codbarra,descricao,vrvenda,unidade,ie) values ')
              .SQL(' (:CODBARRA, :DESCRICAO, :VRVENDA, :UNIDADE, :IE)')
              .AddParan('CODBARRA',FJOSNArray.Get(I).GetValue<String>('codbarra'))
              .AddParan('DESCRICAO',FJOSNArray.Get(I).GetValue<String>('descricao'))
              .AddParan('VRVENDA',FJOSNArray.Get(I).GetValue<String>('vrvenda'))
              .AddParan('UNIDADE',FJOSNArray.Get(I).GetValue<String>('unidade'))
              .AddParan('IE','I')
            .ExceSQL;
        end;
      finally
        FJOSNArray.DisposeOf;
      end;

      uFiredac
        .Active(False)
          .SQLClear.SQL('delete from tab_produtos where ie = ''E''')
        .ExceSQL;
    except
      uFiredac
        .Active(False)
        .SQLClear.SQL('delete from tab_produtos where ie = ''I''')
      .ExceSQL;

      uFiredac
        .Active(False)
        .SQLClear.SQL('update tab_produtos set ie = ''I''')
      .ExceSQL;
      raise;
    end;
  end;

  if FMenProduto.Active then
  begin
    FMenProduto.EmptyDataSet;
    FMenProduto.Close;
  end;
  FMenProduto.CloneCursor(uFiredac
                            .Active(False)
                            .SQLClear
                            .SQL('select * from tab_Produtos')
                          .Open
                          .DataSet);
end;

procedure TDm.ReloandTv;
var
  i: Integer;
begin

  //Receber Tvs do server;
  FJOSNArray := Nil;
  FJOSNArray := uRestDataWare
                  .Resource('ListaTvs')
                  .ClearParans
                  .Execute
                .JSONArray;

  if uRestDataWare.StatusCode = 200 then
  begin
    try
      //Inserir Tvs no banco Local;
      uFiredac
        .Active(False)
          .SQLClear
          .SQL('update tab_tvs set ie = ''E''')
        .ExceSQL;

      for I := 0 to (FJOSNArray.Size - 1) do
      begin
        uFiredac
          .Active(False)
            .SQLClear
            .SQL('Insert Into tab_tvs (idtv,descricao,ie) values ')
            .SQL(' (:IDTV, :DESCRICAO, :IE) ')
            .AddParan('IDTV',FJOSNArray.Get(I).GetValue<String>('idtv'))
            .AddParan('DESCRICAO',FJOSNArray.Get(I).GetValue<String>('descricao'))
            .AddParan('IE','I')
          .ExceSQL;
      end;
    finally
      FJOSNArray.DisposeOf;
    end;

    uFiredac
      .Active(False)
        .SQLClear.SQL('delete from tab_tvs where ie = ''E''')
      .ExceSQL;
  end;

  if FMenTvs.Active then
  begin
    FMenTvs.EmptyDataSet;
    FMenTvs.Close;
  end;
  FMenTvs.CloneCursor(uFiredac
                          .Active(False)
                            .SQLClear
                              .SQL('select * from tab_Tvs')
                            .Open
                            .DataSet);
end;

function TDm.Time(aValue: Integer): TDm;
begin
  FTime := aValue;
end;

function TDm.Time: Integer;
begin
  Result := FTime;
  if FTime = 0 then
    Result := 50000;
end;

function TDm.WidthLayoutImagen: Integer;
begin
  Result := FWidthLayoutImagen;
end;

function TDm.WidthLayoutImagen(aValue: Integer): TDm;
begin
  Result := Self;
  FWidthLayoutImagen := aValue;
end;

end.
