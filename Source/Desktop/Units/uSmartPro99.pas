unit uSmartPro99;

interface

type
  TTipoIntegracao = (tsToledo, tsFilizola, tsOutros);
  TStatus = (tsAdicionar, tsEditar);

type
  TConfiguracao = class
  private
    FTipoIntegracao: TTipoIntegracao;
    FLocalArquivo: String;
  public
    function TipoIntegracaoToStr: String;
    function StrToTipoIntegracao(const pValue: String): TTipoIntegracao;

    property LocalArquivo: String read FLocalArquivo write FLocalArquivo;
    property TipoIntegracao: TTipoIntegracao read FTipoIntegracao write FTipoIntegracao;
    
  end;

type
  TTv = class
  private
    FStatusTela: TStatus;
    FId: Integer;
    FName: String;
    procedure SetName(const Value: String);
  public
    property StatusTela: TStatus read FStatusTela write FStatusTela;
    property IdTV: Integer read FId write FId;
    property NomeTV: String read FName write SetName;
  end;

type
  TSmartPro = class
    FConfiguracao: TConfiguracao;
    FTvs: TTv;
    constructor Create;
    destructor Destroy; override;
    public
      property Config: TConfiguracao read FConfiguracao write FConfiguracao;
      property Tvs: TTv read FTvs write FTvs;
  end;
  
var
  SmartPro : TSmartPro;

implementation

uses
  System.SysUtils, System.StrUtils;

{ Tv }

procedure TTv.SetName(const Value: String);
begin
  if Value = '' then
    raise Exception.Create('Nome da TV e invalido');

  FName := UpperCase(Value);
end;

{ TConfiguracao }

function TConfiguracao.TipoIntegracaoToStr: String;
begin

  case FTipoIntegracao of
  tsToledo:   Result := 'T';
  tsFilizola: Result := 'F';
  tsOutros:   Result := 'O';
  end;

end;

function TConfiguracao.StrToTipoIntegracao(const pValue: String): TTipoIntegracao;
begin

  case AnsiIndexStr(UpperCase(pValue), ['T', 'F', 'O']) of
  0: Result := tsToledo;
  1: Result := tsFilizola;
  2: Result := tsOutros;
  end;

end;

{ TSmartPro }

constructor TSmartPro.Create;
begin
  FConfiguracao := TConfiguracao.Create;
  FTvs          := TTv.Create;
end;

destructor TSmartPro.Destroy;
begin
  FConfiguracao.DisposeOf;
  FTvs.DisposeOf;
  inherited;
end;


end.
