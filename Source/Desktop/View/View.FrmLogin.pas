unit View.FrmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts;

type
  TViewFrmLogin = class(TForm)
    EdtLogin: TEdit;
    EdtSenha: TEdit;
    BtnAcessar: TRectangle;
    LytLogin: TLayout;
    Label3: TLabel;
    LblRodaPe: TLabel;
    Image1: TImage;
    RectClient: TRectangle;
    LblSair: TLabel;
    Layout2: TLayout;
    Label5: TLabel;
    Layout4: TLayout;
    Label6: TLabel;
    RectSenha: TRectangle;
    RectLogin: TRectangle;
    LytBotao: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure BtnAcessarClick(Sender: TObject);
    procedure LblSairClick(Sender: TObject);
  private
    { Private declarations }
    const cVersao : String = '1.0.0';
  public
    { Public declarations }
  end;
var
  ViewFrmLogin: TViewFrmLogin;

implementation

{$R *.fmx}

uses View.FrmPrincipal, uDm;

procedure TViewFrmLogin.BtnAcessarClick(Sender: TObject);
begin
  //if Dm.ValidaLogin(EdtLogin.Text,EdtSenha.Text) then
  //begin
  //  ViewFrmPrincipal := TViewFrmPrincipal.Create(Nil);
  //  ViewFrmPrincipal.Usuario := EdtLogin.Text;
  //  ViewFrmPrincipal.Show;
  //  ViewFrmLogin.Close;
   // ViewFrmLogin.DisposeOf;
  //end
  //else
  //  ShowMessage('Usuario ou senha Invalida');
end;

procedure TViewFrmLogin.FormCreate(Sender: TObject);
begin
  EdtLogin.Text := '';
  EdtSenha.Text := '';

{$IFDEF DEBUG}
  EdtLogin.Text := 'ADMIN';
  EdtSenha.Text := 'ADMIN';
{$ENDIF}

  LblRodaPe.Text :=
  '© 2021 Consolide Registro de Marcas - Todos os direitos reservados.' +
      'Versão: ' + cVersao;
end;

procedure TViewFrmLogin.LblSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
