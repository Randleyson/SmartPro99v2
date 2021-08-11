program Server;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.FrmPrincipal in 'View\View.FrmPrincipal.pas' {FrmPrincipal},
  uServerMethod in 'Units\uServerMethod.pas' {DmServerMethod: TDataModule},
  uDm in 'Units\uDm.pas' {Dm: TDataModule},
  uServer in 'Units\uServer.pas',
  uFireDAC in '..\..\..\..\Global\uFireDAC.pas',
  uAccessKey in '..\..\..\..\Global\uAccessKey.pas',
  uBehaviors in 'Units\uBehaviors.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
