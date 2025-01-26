/// <summary>
/// ***************************************************************************
///
/// Bubbleoid
///
/// Copyright 2025 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://bubbleoid.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Bubbleoid-GGJ2025
///
/// ***************************************************************************
/// File last update : 2025-01-26T13:15:48.000+01:00
/// Signature : 39fcd7c8bbf2427927ae6e1312017466c6a3dbeb
/// ***************************************************************************
/// </summary>

unit cDialogBox;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _ScenesAncestor,
  FMX.Objects,
  FMX.Layouts,
  Olf.FMX.TextImageFrame,
  _ButtonsAncestor,
  cButtonText;

type
  TDialogBox = class(T__SceneAncestor)
    rBody: TRectangle;
    rFooter: TRectangle;
    Layout2: TLayout;
    btnBack: TButtonText;
    rHeader: TRectangle;
    lTitle: TLayout;
    tiTitle: TOlfFMXTextImageFrame;
    VertScrollBox1: TVertScrollBox;
    tContent: TText;
    lModalLock: TLayout;
    lDialogBox: TScaledLayout;
    procedure btnBackClick(Sender: TObject);
    procedure FrameResized(Sender: TObject);
  private
    function GetText: string;
    function GetTitle: string;
    procedure SetText(const Value: string);
    procedure SetTitle(const Value: string);
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
    procedure ResizeTitle;
  public
    property Title: string read GetTitle write SetTitle;
    property Text: string read GetText write SetText;
    class procedure Execute(const AParent: TFMXObject;
      const ATitle, AText: string);
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
    procedure AfterConstruction; override;
  end;

implementation

{$R *.fmx}

uses
  uUIElements,
  udmAdobeStock_497062500,
  uConfig;

{ TDialogBox }

procedure TDialogBox.AfterConstruction;
begin
  inherited;
  tContent.TextSettings.Font.Size := tContent.TextSettings.Font.Size * 2;
end;

procedure TDialogBox.btnBackClick(Sender: TObject);
begin
  HideScene;
end;

class procedure TDialogBox.Execute(const AParent: TFMXObject;
  const ATitle, AText: string);
var
  db: TDialogBox;
begin
  db := TDialogBox.create(AParent);
  db.parent := AParent;
  db.Title := ATitle;
  db.Text := AText;
  db.ShowScene;
end;

procedure TDialogBox.FrameResized(Sender: TObject);
const
  CBorderMargins = 30;
var
  w, h, ratio: single;
begin
  w := lDialogBox.OriginalWidth;
  h := lDialogBox.OriginalHeight;
  if (w > Width - 2 * CBorderMargins) then
  begin
    ratio := lDialogBox.OriginalWidth / (Width - 2 * CBorderMargins);
    w := lDialogBox.OriginalWidth / ratio;
    h := lDialogBox.OriginalHeight / ratio;
  end;
  if h > Height - 2 * CBorderMargins then
  begin
    ratio := lDialogBox.OriginalHeight / (Height - 2 * CBorderMargins);
    w := lDialogBox.OriginalWidth / ratio;
    h := lDialogBox.OriginalHeight / ratio;
  end;
  lDialogBox.BeginUpdate;
  try
    lDialogBox.Width := w;
    lDialogBox.Height := h;
  finally
    lDialogBox.EndUpdate;
  end;
end;

function TDialogBox.GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
  AChar: char): integer;
begin
  if (AChar = 'ç') then
    result := Sender.getImageIndexOfChar('C')
  else
    result := Sender.getImageIndexOfChar(UpperCase(AChar));
end;

function TDialogBox.GetText: string;
begin
  result := tContent.Text;
end;

function TDialogBox.GetTitle: string;
begin
  result := tiTitle.Text;
end;

procedure TDialogBox.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TDialogBox.ResizeTitle;
begin
  while (tiTitle.Width > lTitle.Width) do
  begin
    tiTitle.Height := tiTitle.Height - 3;
    tiTitle.Text := tiTitle.Text;
    // TODO : replace by RefreshText or remove if TextImageFrame refresh itself when its height change
  end;
end;

procedure TDialogBox.SetText(const Value: string);
begin
  tContent.Text := Value;
end;

procedure TDialogBox.SetTitle(const Value: string);
begin
  tiTitle.Text := Value;
end;

procedure TDialogBox.ShowScene;
begin
  inherited;
  tiTitle.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  tiTitle.Font := dmAdobeStock_497062500.ImageList;
  ResizeTitle;

  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnBack, nil, nil, nil, nil, true, true);
end;

procedure TDialogBox.TranslateTexts(const Language: string);
begin
  inherited;
  if tconfig.Current.Language = 'fr' then
    btnBack.Text := 'Retour'
  else
    btnBack.Text := 'Back';
end;

end.
