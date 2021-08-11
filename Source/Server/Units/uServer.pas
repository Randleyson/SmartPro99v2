unit uServer;

interface

type
  TUnd = (tuKg,tuUnd);

type
  TConfig = class
  private
    FPathArquivoInteg: String;
    FTimeProxSincr: Integer;
  public
    property PathArquivoInteg: String read FPathArquivoInteg write FPathArquivoInteg;
    property TimeProxSincr: Integer read FTimeProxSincr write FTimeProxSincr;

  end;

type
  TProduto = class
  private
    FCodBarra: String;
    FDescricao: String;
    FVrVenda: String;
    FUnid: TUnd;
  public
    function UndToStr: String;
    property CodBarra: String read FCodBarra write FCodBarra;
    property Descricao: String read FDescricao write FDescricao;
    property VrVenda: String read FVrVenda write FVrVenda;
    property Unidade: TUnd read FUnid write FUnid;

  end;

type
  TServer = class
    constructor Create;
    destructor Destroy; override;
  private
    FConfig: TConfig;
    FProduto: TProduto;

  public
    property Config: TConfig read FConfig write FConfig;
    property Prod: TProduto read FProduto write FProduto;
  end;

var
  Server: TServer;

implementation

{ TServer }

constructor TServer.Create;
begin

  FProduto := TProduto.Create;
  FConfig := TConfig.Create;

end;

destructor TServer.Destroy;
begin

  FProduto.DisposeOf;
  FConfig.DisposeOf;
  inherited;
end;

{ TProduto }

function TProduto.UndToStr: String;
begin

  case FUnid of
  tuKg  : Result := 'KG';
  tuUnd : Result := 'UN';
  end;

end;

end.
