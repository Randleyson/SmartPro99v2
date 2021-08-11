unit uFiredac;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,
  FireDAC.Dapt, FireDAC.Comp.DataSet
  {$IFDEF ANDROID}
  ,System.IOUtils
  {$ENDIF};

type
  TFiredac = class
    private
      FDConnection: TFDConnection;
      FQuery: TFDQuery;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: TFiredac;
      function Active (aValue: Boolean): TFiredac;
      function AddParan(aParem: String; aValue: Variant): TFiredac;
      function DataSet: TFDDataSet;
      function ExceSQL: TFiredac;
      function Open: TFiredac;
      function SQL(aValue: String) : TFiredac;
      function SQLClear: TFiredac;
  end;

var
  Firedac: TFiredac;

implementation

uses
  System.SysUtils;

{ TModelComponnentsConeectionFiredac }

function TFiredac.Active(aValue: Boolean): TFiredac;
begin
  Result := Self;
  fQuery.Active := aValue;
end;

function TFiredac.AddParan(aParem: String; aValue: Variant): TFiredac;
begin
  Result := Self;
  FQuery.ParamByName(aParem).Value := aValue;
end;

constructor TFiredac.Create;
begin

  FDConnection := TFDConnection.Create(Nil);
  FQuery := TFDQuery.Create(Nil);
  FQuery.Connection := FDConnection;

  FDConnection.Params.DriverID := 'SQLite';
  FDConnection.Params.Add('LockingMode=Normal');
  {$IFDEF ANDROID}
  FDConnection.Params.Database := TPath.Combine(TPath.GetDocumentsPath, 'Mobile3.db');
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  FDConnection.Params.Database := 'D:\Projetos\SmartPro99\trunk\Db\Mobile3.db';
  {$ENDIF}

  try
    FDConnection.Connected := True;
  Except
    raise Exception.Create('Erro ao conectar a banco de dados');
  end;

end;

function TFiredac.DataSet: TFDDataSet;
begin
  Result := fQuery;
end;

destructor TFiredac.Destroy;
begin
  FQuery.DisposeOf;
  FDConnection.DisposeOf;
  inherited;
end;

function TFiredac.ExceSQL: TFiredac;
begin
  Result := Self;
  FQuery.ExecSQL;
end;

class function TFiredac.New: TFiredac;
begin
  Result := Self.Create;
end;

function TFiredac.Open: TFiredac;
begin
  Result := Self;
  FQuery.Open;
end;

function TFiredac.SQL(aValue: String): TFiredac;
begin
  Result := self;
  FQuery.SQL.Add(aValue);
end;

function TFiredac.SQLClear: TFiredac;
begin
  Result := self;
  FQuery.SQL.Clear;
end;

end.
