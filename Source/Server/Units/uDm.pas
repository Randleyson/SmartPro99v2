unit uDm;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  uFiredac, FMX.StdCtrls;

type
  TDm = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    uFiredac: TFiredac;
  public
    { Public declarations }
    function JSONArrayTv: TJSONArray;
    function JSONArrayProduto(const aParant: Integer): TJSONArray;
    procedure SincronizarProdutos(pProgressBar: TProgressBar);
    procedure LerConfiguracao;
    procedure UpdateTimeSincr;
    function LerChaveRegistro: String;
  end;

var
  Dm: TDm;

implementation

uses
  Data.DB, System.IniFiles, uServer, Vcl.Forms;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDm.DataModuleCreate(Sender: TObject);
begin

  uFiredac := TFiredac.Create;
  uFireDac.PathIni := ExtractFileDir(application.ExeName) + '\Config.ini';
  uFireDac.AbreConexaoBanco(True);

end;

procedure TDm.DataModuleDestroy(Sender: TObject);
begin
  uFiredac.DisposeOf;
end;

procedure TDm.SincronizarProdutos(pProgressBar: TProgressBar);
var
  vTextFile: TextFile;
  vLinha: String;
  vDataSet: TDataSet;
  vStringList: TStringList;

begin

  with Server do
  begin
    pProgressBar.Value := 1;
    vStringList        := TStringList.Create;
    try
      vStringList.LoadFromFile(Config.PathArquivoInteg);
      pProgressBar.Max := vStringList.Count;
    finally
      vStringList.DisposeOf;
    end;

      uFiredac
        .Active(False)
          .SQLClear
            .SQL('Update produtos set EXISTENOARQ = :PARANTER')
            .AddParan('PARANTER','N')
          .ExceSQL;

      AssignFile(vTextFile, Config.PathArquivoInteg);
      reset(vTextFile);
      try
        while not EOF(vTextFile) do
        begin

          Readln(vTextFile, vLinha);
          if Length(vLinha) < 50 then
            Exit;
          Prod.CodBarra := Copy(vLinha, 6, 6);
          Prod.Descricao := Copy(vLinha, 21, 25);
          Prod.VrVenda := Copy(Copy(vLinha, 12, 6), 0, 4) + '.' + Copy(Copy(vLinha, 12, 6), 5, 2);

          case StrToInt(Copy(vLinha,5,1)) of
          0: Prod.Unidade := tuKg;
          1: Prod.Unidade := tuUnd;
          end;

          if uFiredac
              .Active(False)
                .SQLClear
                .SQL('select * from produtos where codbarra = :CODBARRA')
                .AddParan('CODBARRA',Prod.CodBarra)
                .Open
              .DataSet.RecordCount > 0 then
            uFiredac
              .Active(False)
                .SQLClear
                .SQL(' update produtos set descricao = :DESCRICAO,')
                .SQL(' vrvenda = :VRVENDA, Unidade = :UNIDADE, EXISTENOARQ= :EXISTENOARQ')
                .SQL(' WHERE codbarra = :CODBARRA')
                .AddParan('DESCRICAO',Prod.Descricao)
                .AddParan('VRVENDA',Prod.VrVenda)
                .AddParan('UNIDADE',Prod.UndToStr)
                .AddParan('EXISTENOARQ','S')
                .AddParan('CODBARRA',Prod.CodBarra)
              .ExceSQL
          else
            uFiredac
              .Active(False)
                .SQLClear
                .SQL('INSERT INTO produtos (codbarra,descricao,vrvenda,unidade,existenoarq)')
                .SQL(' values (:CODBARRA, :DESCRICAO, :VRVENDA,:UNIDADE, :EXISTENOARQ)')
                .AddParan('CODBARRA',Prod.CodBarra)
                .AddParan('DESCRICAO',Prod.Descricao)
                .AddParan('VRVENDA',Prod.VrVenda)
                .AddParan('UNIDADE',Prod.UndToStr)
                .AddParan('EXISTENOARQ','S')
              .ExceSQL;
          pProgressBar.Value := pProgressBar.Value + 1
        end;
        uFiredac
          .Active(False)
            .SQLClear
            .SQL('Delete from produtos where EXISTENOARQ = :EXISTENOARQ')
            .AddParan('EXISTENOARQ','N')
          .ExceSQL;
      finally
        CloseFile(vTextFile);
      end;

  end;
end;

procedure TDm.UpdateTimeSincr;
begin

  uFiredac
    .Active(False)
    .SQLClear
      .SQL('update configuracao set TimeSincronos = :TimeSincronos' )
      .AddParan('TimeSincronos',Server.Config.TimeProxSincr)
      .ExceSQL;

end;

function TDm.JSONArrayProduto(const aParant: Integer): TJSONArray;
var
  DataSet: TDataSet;
  JSONArray: TJSONArray;
  JSON: TJSONObject;
begin
  DataSet := uFiredac.Active(False)
              .SQLClear
              .SQL(' select codbarra,descricao,vrvenda,unidade from produtos p ')
              .SQL(' left join tv_prod tp on tp.codproduto = p.codbarra ')
              .SQL(' where codtv = :IDTV ')
              .AddParan('IDTV', IntToStr(aParant))
              .Open
            .DataSet;

  try
    JSONArray := TJSONArray.Create;
    DataSet.First;
    while not DataSet.Eof do
    begin
      JSON := TJSONObject.Create;
      JSON.AddPair('codbarra',DataSet.Fields[0].AsString);
      JSON.AddPair('descricao',DataSet.Fields[1].AsString);
      JSON.AddPair('vrvenda',DataSet.Fields[2].AsString);
      JSON.AddPair('unidade',DataSet.Fields[3].AsString);
      JSONArray.AddElement(JSON);
      DataSet.Next;
    end;
    Result := JSONArray;
  finally
    uFiredac.Active(False);
  end;
end;

function TDm.JSONArrayTv: TJSONArray;
var
  DataSet: TDataSet;
  JSONArray: TJSONArray;
  JSON: TJSONObject;
begin

  DataSet := uFiredac.Active(False).SQLClear.SQL('select idtv,descricao from tvs order by idtv').Open.DataSet;
  try
    JSONArray := TJSONArray.Create;
    DataSet.First;
    while not DataSet.Eof do
    begin
      JSON := TJSONObject.Create;
      JSON.AddPair('idtv',DataSet.Fields[0].AsString);
      JSON.AddPair('descricao',DataSet.Fields[1].AsString);
      JSONArray.AddElement(JSON);
      DataSet.Next;
    end;
    Result := JSONArray;
  finally
    uFiredac.Active(False);
  end;

end;


function TDm.LerChaveRegistro: String;
begin

  try

    Result := uFiredac
              .Active(False)
              .SQLClear
              .SQL('select KEYACCESS from configuracao')
              .Open
              .DataSet.Fields[0].AsString;
    uFiredac.Active(False);

  except
    raise Exception.Create('Error ao ler a chave de acesso');
  end;

end;

procedure TDm.LerConfiguracao;
var
  DataSet: TDataSet;
begin

  DataSet := uFiredac
              .Active(False)
              .SQLClear
              .SQL(' select Localarquivo, TimeSincronos from configuracao')
              .Open
            .DataSet;

  try

    with Server.Config do
    begin
      PathArquivoInteg := DataSet.FieldByName('Localarquivo').AsString;
      TimeProxSincr    := DataSet.FieldByName('TimeSincronos').AsInteger;
    end;

  finally
    DataSet.Close;
  end;

end;

end.
