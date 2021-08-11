program AppSmartPro99;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Principal in 'View\View.Principal.pas' {FrmPrincipal},
  View.TabelaPreco in 'View\View.TabelaPreco.pas' {ViewTabelaPreco: TFrame},
  View.Configuracao in 'View\View.Configuracao.pas' {ViewConfiguracoes: TFrame},
  View.Frames.TabelaCores in 'View\Frames\View.Frames.TabelaCores.pas' {FrameTabelaCores: TFrame},
  View.Frames.ItemLista in 'View\Frames\View.Frames.ItemLista.pas' {FrameItemList: TFrame},
  uBehaviors in 'Untis\uBehaviors.pas',
  uDm in 'Untis\uDm.pas' {Dm: TDataModule},
  uFireDAC in '..\..\..\..\Global\uFireDAC.pas',
  uRestDataWare in '..\..\..\..\Global\uRestDataWare.pas',
  uLoading in '..\..\..\..\Global\uLoading.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
