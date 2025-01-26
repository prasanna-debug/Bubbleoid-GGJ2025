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
/// File last update : 2025-01-26T16:23:48.000+01:00
/// Signature : 3106119d9191532244724468dc9d57a67b335cea
/// ***************************************************************************
/// </summary>

unit uSceneBackground;

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
  uStarFieldData;

type
  TSceneBackground = class(T__SceneAncestor)
    rBackground: TRectangle;
    imgBubbleField: TImage;
    LoopAnim: TTimer;
    procedure LoopAnimTimer(Sender: TObject);
    procedure FrameResized(Sender: TObject);
  private
  protected
    CenterX, CenterY: Single;
  public
    // TODO : transférer les variables dans un TGameData personnalisé
    BubbleField: TStarsList;
    SpeedX, SpeedY, SpeedZ: Single;
    procedure ShowScene; override;
    procedure HideScene; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

uses
  uConsts;

constructor TSceneBackground.Create(AOwner: TComponent);
begin
  inherited;
  BubbleField := TStarsList.Create(CNBBubbles, CFieldSize, CFieldSize,
    CFieldSize);
  SpeedX := 0;
  SpeedY := 0;
  SpeedZ := 1;
end;

destructor TSceneBackground.Destroy;
begin
  BubbleField.free;
  inherited;
end;

procedure TSceneBackground.FrameResized(Sender: TObject);
begin
  CenterX := (width / 2);
  CenterY := (height / 2);
end;

procedure TSceneBackground.HideScene;
begin
  inherited;

  LoopAnim.Enabled := false;
end;

procedure TSceneBackground.LoopAnimTimer(Sender: TObject);
const
  CCircleDiameter = 128;
  CCircleRadius = CCircleDiameter / 2;
var
  BMP: TBitmap;
  BMPScale: Single;
  i: integer;
  X, Y: Single;
  BubbleRadius: Single;
begin
  BMPScale := imgBubbleField.Bitmap.BitmapScale;

  // création d'un bitmap
  BMP := TBitmap.Create(round(width * BMPScale), round(height * BMPScale));
  try
    BMP.BitmapScale := BMPScale;

    BMP.Clear(talphacolors.Darkblue);

    BMP.canvas.BeginScene;
    try
      BMP.canvas.Fill.Color := talphacolors.White;
      BMP.canvas.stroke.Kind := TBrushKind.None;

      // parcourt de la liste des étoiles pour affichage de celles qui sont devant nous
      for i := 0 to CNBBubbles - 1 do
      begin
        BubbleField[i].X := BubbleField[i].X - SpeedX;
        if (BubbleField[i].X > CFieldSize) then
          while (BubbleField[i].X > CFieldSize) do
            BubbleField[i].X := BubbleField[i].X - 2 * CFieldSize
        else if (BubbleField[i].X < -CFieldSize) then
          while (BubbleField[i].X < -CFieldSize) do
            BubbleField[i].X := BubbleField[i].X + 2 * CFieldSize;
        BubbleField[i].Y := BubbleField[i].Y - SpeedY;
        if (BubbleField[i].Y > CFieldSize) then
          while (BubbleField[i].Y > CFieldSize) do
            BubbleField[i].Y := BubbleField[i].Y - 2 * CFieldSize
        else if (BubbleField[i].Y < -CFieldSize) then
          while (BubbleField[i].Y < -CFieldSize) do
            BubbleField[i].Y := BubbleField[i].Y + 2 * CFieldSize;
        BubbleField[i].Z := BubbleField[i].Z - SpeedZ;
        if (BubbleField[i].Z > CFieldSize) then
          while (BubbleField[i].Z > CFieldSize) do
            BubbleField[i].Z := BubbleField[i].Z - 2 * CFieldSize
        else if (BubbleField[i].Z < -CFieldSize) then
          while (BubbleField[i].Z < -CFieldSize) do
            BubbleField[i].Z := BubbleField[i].Z + 2 * CFieldSize;

        if (BubbleField[i].Z > 0) and (BubbleField[i].Z < CCircleDiameter) then
        begin
          X := CenterX + SpeedX + BubbleField[i].X / BubbleField[i].Z * 5;
          Y := CenterY + SpeedY - BubbleField[i].Y / BubbleField[i].Z * 5;
          if (X >= 0) and (X < width) and (Y >= 0) and (Y < height) then
          begin
            BubbleRadius := CCircleDiameter / BubbleField[i].Z;
            BMP.canvas.FillEllipse(trectf.Create(X - BubbleRadius,
              Y - BubbleRadius, X + BubbleRadius, Y + BubbleRadius),
              1 - 0.7 / BubbleField[i].Z);
            // TODO : remplacer les ellipses par des images de bulles (TSVGBubbles)
          end;
          // TODO : si un élément passe de Z>0 à Z<0, tester collision avec zone du joueur si le jeu est actif
        end;
      end;
    finally
      BMP.canvas.EndScene;
    end;
    // switch du bitmap avec celui de l'image
    imgBubbleField.Bitmap.Assign(BMP);
  finally
    BMP.free;
  end;

  // TODO : rendre la vitesse maximale paramétrable et peut-être modifiable par les joueurs
  if SpeedZ < 10 then
    SpeedZ := SpeedZ * 1.1;
end;

procedure TSceneBackground.ShowScene;
begin
  inherited;
  SendToBack;

  LoopAnim.interval := round(1000 / cfps);
  LoopAnim.Enabled := true;
end;

end.
