unit View.Splash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TFrmSplash = class(TForm)
    Image1: TImage;
    tmSplash: TTimer;
    procedure FormShow(Sender: TObject);
    procedure tmSplashTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;

implementation

{$R *.fmx}

uses  View.FrmPrincipal,
      uDm,
      View.Mensagem;

procedure TFrmSplash.FormShow(Sender: TObject);
var
  TmpMain: ^TCustomForm;
begin

  // Os Compomente que são criado aqui são destruido no finalization no uBehavier;
  try
    FrmMensagem      := TFrmMensagem.Create(Nil);

    ViewFrmPrincipal := TViewFrmPrincipal.Create(Nil);
    TmpMain          := @Application.Mainform;
    TmpMain^         := ViewFrmPrincipal;

    Dm               := TDm.Create(Nil);

    tmSplash.Enabled := True;
  except
    Application.Terminate;

  end;

end;


procedure TFrmSplash.tmSplashTimer(Sender: TObject);
begin
  tmSplash.Enabled := False;
  ViewFrmPrincipal.Show;
  FrmSplash.Close;

end;

end.
