unit View.Mensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.Filter.Effects, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.Layouts;

type
  TImagen = (tiConfirmacao,tiAlerta,tiAtencao);
type
  TTipo = (ttInformativa);



type
  TFrmMensagem = class(TForm)
    imgAlerta: TImage;
    imgConfirmacao: TImage;
    FillRGBEffect1: TFillRGBEffect;
    FillRGBEffect2: TFillRGBEffect;
    RectOk: TRectangle;
    Rectangle2: TRectangle;
    lytMensagemOk: TLayout;
    Label1: TLabel;
    lblMesagem: TLabel;
    Layout2: TLayout;
    imgAtencao: TImage;
    imgMsg: TImage;
    procedure RectOkClick(Sender: TObject);
  private
    { Private declarations }
    FMensagem: String;
    FImagen: TImagen;
    procedure MensagemInformativa;
  public
    { Public declarations }
    procedure ShowMensagem(pMensagem: String; pTipo: TTipo = ttInformativa;
      pImagen: TImagen = tiAlerta);

  end;

var
  FrmMensagem: TFrmMensagem;

implementation

{$R *.fmx}

procedure TFrmMensagem.MensagemInformativa;
begin

  Self.ClientHeight := 200;
  Self.ClientWidth  := 600;

  lytMensagemOk.Visible  := True;

  case FImagen of
  tiConfirmacao: imgMsg.Bitmap := imgConfirmacao.Bitmap;
  tiAlerta: imgMsg.Bitmap := imgAlerta.Bitmap;
  tiAtencao: imgMsg.Bitmap := imgAtencao.Bitmap;
  end;

  lblMesagem.Text := FMensagem;

end;

procedure TFrmMensagem.RectOkClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmMensagem.ShowMensagem(pMensagem: String; pTipo: TTipo = ttInformativa;
  pImagen: TImagen = tiAlerta);
begin

  FMensagem := pMensagem;
  FImagen   := pImagen;

  lytMensagemOk.Visible := False;

  case pTipo of
    ttInformativa : MensagemInformativa;
  end;

  Self.ShowModal;


end;

end.
