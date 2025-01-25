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
/// File last update : 2025-01-25T22:16:28.000+01:00
/// Signature : 3a77a4483e826a419619b0c5707797e54efd07da
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
  Olf.FMX.TextImageFrame,
  FMX.Layouts,
  FMX.Objects,
  _ButtonsAncestor,
  cButtonIcon,
  cButtonText;

type
  TDialogBox = class(TFrame)
    rHeader: TRectangle;
    rBody: TRectangle;
    rFooter: TRectangle;
    VertScrollBox1: TVertScrollBox;
    tiTitle: TOlfFMXTextImageFrame;
    Layout1: TLayout;
    Layout2: TLayout;
    btnBack: TButtonText;
    tContent: TText;
  private
    procedure SetText(const Value: string);
    procedure SetTitle(const Value: string);
    function GetText: string;
    function GetTitle: string;
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
  public
    procedure AfterConstruction; override;
    property Title: string read GetTitle write SetTitle;
    property Text: string read GetText write SetText;
    class procedure Execute(const AOwner: TComponent;
      const ATitle, AText: string);
  end;

  // TODO : adapter taille de la boite de dialogue à son conteneur pour éviter de déborder en largeur ou hauteur
  // TODO : intercepter les changements d'orientation sur smartphones et tablettes
  // TODO : référencer le bouton BACK
  // TODO : prendre en charge la traduction
  // TODO : s'assurer que le titre ne déborde pas de la largeur de son conteneur

implementation

{$R *.fmx}

uses
  udmAdobeStock_497062500,
  uUIElements,
  uConfig;
{ TDialogBox }

procedure TDialogBox.AfterConstruction;
begin
  inherited;
  tiTitle.Font := dmAdobeStock_497062500.ImageList;
  tiTitle.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  tiTitle.Text := '';
  TUIItemsList.Current.AddControl(btnBack, nil, nil, nil, nil, true, true);
  // TODO : traduction à adapter plus tard
  if tconfig.Current.Language = 'fr' then
    btnBack.Text := 'Retour'
  else
    btnBack.Text := 'Back';
end;

class procedure TDialogBox.Execute(const AOwner: TComponent;
  const ATitle, AText: string);
var
  db: TDialogBox;
begin
  db := TDialogBox.create(AOwner);
  db.Title := ATitle;
  db.Text := AText;
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

procedure TDialogBox.SetText(const Value: string);
begin
  tContent.Text := Value;
end;

procedure TDialogBox.SetTitle(const Value: string);
begin
  tiTitle.Text := Value;
end;

end.
