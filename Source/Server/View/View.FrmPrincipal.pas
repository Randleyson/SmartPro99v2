unit View.FrmPrincipal;

interface
uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  FMX.Forms,
  FMX.TabControl,
  FMX.ListBox,
  StrUtils,
  uDWAbout,
  uRESTDWBase;

  type
  TFrmPrincipal = class(TForm)
    RESTPooler: TRESTServicePooler;
    TabControl: TTabControl;
    TabConfiguracao: TTabItem;
    LytBotao: TLayout;
    BtnStart: TRectangle;
    BtnStop: TRectangle;
    LblRodaPe: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MmLogs: TMemo;
    CliStatus: TCircle;
    LblOnOff: TLabel;
    TmSincronizaProduto: TTimer;
    PBarSincronizara: TProgressBar;
    LytProgressoBar: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    LblProxSincronizacao: TLabel;
    lblLocalarq: TLabel;
    Rectangle1: TRectangle;
    TabGeral: TTabItem;
    Label3: TLabel;
    EdtTime: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    TabLogs: TTabItem;
    procedure FormDestroy(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure TmSincronizaProdutoTimer(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure EdtTimeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAux: Integer;
    procedure StatusServer(Values: Boolean);
    procedure SincronizarProdutos;
  public
  { Public declarations }
    const
    cVersao: String = '4.0.0';
    procedure EscreveMmLogs(pErro: String);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  System.IniFiles,
  uDm,
  uServerMethod,
  uServer,
  uAccessKey;

{$R *.fmx}

procedure TFrmPrincipal.SincronizarProdutos;
begin

  TmSincronizaProduto.Enabled := False;
  PBarSincronizara.Visible    := True;
  LblProxSincronizacao.Text   := 'Agurade ... Sincronizando';

  EscreveMmLogs('Sincronizacao Inicia');
  TThread.CreateAnonymousThread(
  procedure
      begin
        try
          try
            Dm.SincronizarProdutos(PBarSincronizara);
          except
            raise
          end;

        finally

          TThread.Synchronize(nil,
            procedure
            begin
              EscreveMmLogs('Sincronizacao finalizada');
              PBarSincronizara.Visible := False;
              TmSincronizaProduto.Enabled := RESTPooler.Active;
            end);
        end;
      end).Start;
end;

procedure TFrmPrincipal.StatusServer(Values: Boolean);
begin

  if not TAccessKey.ValidaKey(Dm.LerChaveRegistro) then
  begin
    ShowMessage('Chave de registro não e validar' + #13 + 'Acesse o RP para ativar um nova chave');
    Application.Terminate;
  end;

  FrmPrincipal.BtnStop.Enabled  := Values;
  FrmPrincipal.BtnStart.Enabled := not Values;
  TmSincronizaProduto.Enabled   := Values;
  RESTPooler.Active             := Values;
  LblProxSincronizacao.Text     := IntToStr(Server.Config.TimeProxSincr);
  FAux                          := Server.Config.TimeProxSincr;
  if Values then
  begin
    LblOnOff.Text         := 'ON';
    CliStatus.Fill.Color  := TAlphaColor($FF0EE515);
    EscreveMmLogs('Server Iniciado');
  end
  else
  begin
    LblOnOff.Text        := 'OFF';
    CliStatus.Fill.Color := TAlphaColor($FFE50E0E);
    MmLogs.Lines.Add('Serviço parado ...');
  end;
end;

procedure TFrmPrincipal.TmSincronizaProdutoTimer(Sender: TObject);
begin

  if FAux = 0 then
  begin

    if Server.Config.TimeProxSincr = 0 then
      Exit;

    FAux := Server.Config.TimeProxSincr;
    SincronizarProdutos;
  end;

  FAux := FAux-1;
  LblProxSincronizacao.Text := IntToStr(FAux) + ' Seg.';

end;

procedure TFrmPrincipal.TrackBarChange(Sender: TObject);
begin
  LblProxSincronizacao.Text := IntToStr(Server.Config.TimeProxSincr);
end;

procedure TFrmPrincipal.BtnStartClick(Sender: TObject);
begin
  StatusServer(True);;
end;

procedure TFrmPrincipal.BtnStopClick(Sender: TObject);
begin
  StatusServer(False);
end;

procedure TFrmPrincipal.EdtTimeExit(Sender: TObject);
begin

  Server.Config.TimeProxSincr := StrToIntDef(EdtTime.Text,0);
  Dm.UpdateTimeSincr;

end;

procedure TFrmPrincipal.EscreveMmLogs(pErro: String);
begin
  MmLogs.Lines.Add(pErro);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin

  Dm     := TDm.Create(Nil);
  Server := TServer.Create;
  DmServerMethod := TDmServerMethod.Create(Nil);

end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin

  StatusServer(False);
  DmServerMethod.DisposeOf;
  Dm.DisposeOf;
  Server.DisposeOf;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin

  RESTPooler.ServerMethodClass := TDmServerMethod;
  LblRodaPe.Text := '© 2021 Consolide Registro de Marcas - Todos os direitos reservados.' +
                     'Versão: ' + cVersao;


  PBarSincronizara.Visible    := False;
  TmSincronizaProduto.Enabled := False;
  TabControl.ActiveTab        := TabGeral;
  MmLogs.Lines.Clear;
  Dm.LerConfiguracao;

  lblLocalarq.Text          := 'Local do arquivo: ' + Server.Config.PathArquivoInteg;
  LblProxSincronizacao.Text := IntToStr(Server.Config.TimeProxSincr) + ' Seg.';
  EdtTime.Text              := IntToStr(Server.Config.TimeProxSincr);

  StatusServer(True);

end;
end.
