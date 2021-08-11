program SmartPro99;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.FrmLogin in 'View\View.FrmLogin.pas' {ViewFrmLogin},
  View.FrmPrincipal in 'View\View.FrmPrincipal.pas' {ViewFrmPrincipal},
  View.Frame.Pesquisa in 'View\Frame\View.Frame.Pesquisa.pas' {FramePesquisa: TFrame},
  View.Frame.Cabecalho in 'View\Frame\View.Frame.Cabecalho.pas' {FrameCabecalho: TFrame},
  View.Frame.PaletaCores in 'View\Frame\View.Frame.PaletaCores.pas' {FramePaletaCores: TFrame},
  uDm in 'Units\uDm.pas' {Dm: TDataModule},
  View.Configuracao in 'View\View.Configuracao.pas' {FrameConfiguracao: TFrame},
  View.CadProdutos in 'View\View.CadProdutos.pas' {FrameCadProdutos: TFrame},
  View.CadTVs in 'View\View.CadTVs.pas' {FrameCadTVs: TFrame},
  View.Mensagem in 'View\View.Mensagem.pas' {FrmMensagem},
  uBehaviors in 'Units\uBehaviors.pas',
  View.splash in 'View\View.splash.pas' {FrmSplash},
  uSmartPro99 in 'Units\uSmartPro99.pas',
  uFireDAC in '..\..\..\..\Global\uFireDAC.pas',
  uAccessKey in '..\..\..\..\Global\uAccessKey.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.Run;
end.
