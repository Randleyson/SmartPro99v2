unit uBehaviors;

interface

uses
  System.SysUtils,
  System.UiTypes,
  FMX.Forms;

type
  TModelBehaviors = class
    private
      FVersao: String;
      const cVersao: String = '1.0.0';
      procedure BehaviorsException( Sender : TObject; E: Exception);
    public
      property Versao: String read FVersao;
      constructor Create;
      destructor Destroy; override;
  end;

var
  ModelBehaviors : TModelBehaviors;

implementation

uses
  FMX.Dialogs;


{ TModelBehaviors }

procedure TModelBehaviors.BehaviorsException(Sender: TObject; E: Exception);
begin
  ShowMessage(E.Message);
end;

constructor TModelBehaviors.Create;
begin
  ReportMemoryLeaksOnShutdown := True;
  Application.OnException := BehaviorsException;
end;

destructor TModelBehaviors.Destroy;
begin
  inherited;
end;

initialization
  ModelBehaviors := TModelBehaviors.Create;

finalization
  ModelBehaviors.DisposeOf;

end.
