unit uBehaviors;

interface

uses
  System.SysUtils,
  System.UiTypes,
  FMX.Forms;

type
  TModelBehaviors = class
    private
      procedure BehaviorsException( Sender : TObject; E: Exception);
    public
      constructor Create;
      destructor Destroy; override;
  end;

var
  ModelBehaviors : TModelBehaviors;

implementation

uses
  FMX.Dialogs,
  View.Mensagem,
  View.FrmPrincipal,
  uDm,
  View.Splash;


{ TModelBehaviors }

procedure TModelBehaviors.BehaviorsException(Sender: TObject; E: Exception);
begin
  FrmMensagem.ShowMensagem(E.Message);
end;

constructor TModelBehaviors.Create;
begin
  ReportMemoryLeaksOnShutdown := True;
  Application.OnException     := BehaviorsException;
end;

destructor TModelBehaviors.Destroy;
begin

  inherited;
end;

initialization
  ModelBehaviors   := TModelBehaviors.Create;

finalization
  ModelBehaviors.DisposeOf;
  FreeAndNil(Dm);
  FreeAndNil(ViewFrmPrincipal);
  FreeAndNil(FrmMensagem);

end.
