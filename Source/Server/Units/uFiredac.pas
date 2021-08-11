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
  FireDAC.Dapt,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB
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
      function Active (aValue: Boolean): TFiredac;
      function AddParan(aParem: String; aValue: Variant): TFiredac;
      function DataSet: TDataSet;
      function ExceSQL: TFiredac;
      function Open: TFiredac;
      function SQL(aValue: String) : TFiredac;
      function SQLClear: TFiredac;
  end;

implementation

uses
  System.SysUtils, System.IniFiles, VCl.Forms, FMX.Dialogs;

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

  FDConnection      := TFDConnection.Create(Nil);
  FQuery            := TFDQuery.Create(Nil);
  FQuery.Connection := FDConnection;

  FDConnection.LoginPrompt := False;
  FDConnection.Params.Clear;
  FDConnection.Params.Add('LockingMode=Normal');
  FDConnection.Params.LoadFromFile(ExtractFileDir(application.ExeName) + '\Config.ini');

  try
    FDConnection.Connected := True;
  Except
    raise Exception.Create('Erro ao conectar a banco de dados');

  end;

end;

function TFiredac.DataSet: TDataSet;
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
