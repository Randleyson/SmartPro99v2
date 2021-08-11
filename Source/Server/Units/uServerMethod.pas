unit uServerMethod;

interface

uses
  System.SysUtils,
  System.Classes,
  uDWAbout,
  uRESTDWServerEvents,
  uDWDataModule,
  uDWJSONObject,
  System.json,
  uDWConsts;

type
  TDmServerMethod = class(TServerMethodDataModule)
    DWSEvents: TDWServerEvents;
    procedure DWServerEvents1EventsHoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWSEventsEventsVersaoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWSEventsEventsListaTvReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWSEventsEventsListarProdutosReplyEventByType
      (var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmServerMethod: TDmServerMethod;

implementation

uses
  View.FrmPrincipal, uDm;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

//Hora
procedure TDmServerMethod.DWServerEvents1EventsHoraReplyEvent
  (var Params: TDWParams; var Result: string);
begin
  Result := '{"hora":"' + FormatDateTime('hh:mm:ss', now) + '"}';

end;

//Produtos Tv
procedure TDmServerMethod.DWSEventsEventsListarProdutosReplyEventByType
  (var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
begin
  Result := Dm.JSONArrayProduto(Params.ItemsString['IdTv'].AsInteger).ToString;
end;

//Tvs
procedure TDmServerMethod.DWSEventsEventsListaTvReplyEventByType
  (var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
begin
  Result := Dm.JSONArrayTv.ToString;
end;

//Versao Server
procedure TDmServerMethod.DWSEventsEventsVersaoReplyEvent(var Params: TDWParams;
  var Result: string);
begin
  Result := '{"Versao":"' + FrmPrincipal.cVersao + '"}'

end;

end.
