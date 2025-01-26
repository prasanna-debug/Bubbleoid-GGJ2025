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
/// File last update : 2025-01-26T19:38:52.000+01:00
/// Signature : 64d1a152b84e0fc6fb9514a01c1272a266889a70
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
    imgBubbleField: TImage;
    LoopAnim: TTimer;
    UserCircle: TCircle;
    procedure LoopAnimTimer(Sender: TObject);
    procedure FrameResized(Sender: TObject);
  private
  protected
    CenterX, CenterY: Single;
  public
    // TODO : transférer les variables dans un TGameData personnalisé
    BubbleField: TStarsList;
    UserCircleCenterX, UserCircleCenterY, UserCircleRadius: Single;
    IsPlaying: boolean;
    procedure ShowScene; override;
    procedure HideScene; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitGame;
    procedure RefreshUserCircle;
  end;

implementation

{$R *.fmx}

uses
  uConsts,
  uGameData,
  uScene;

constructor TSceneBackground.Create(AOwner: TComponent);
begin
  inherited;
  BubbleField := TStarsList.Create(CNBBubbles, CFieldSize, CFieldSize,
    CFieldSize);
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
  RefreshUserCircle;
end;

procedure TSceneBackground.HideScene;
begin
  inherited;

  LoopAnim.Enabled := false;
end;

procedure TSceneBackground.InitGame;
begin
  IsPlaying := tgamedata.DefaultGameData.IsPlaying;
  RefreshUserCircle;
  SpeedX := 0;
  SpeedY := 0;
  SpeedZ := 1;
end;

procedure TSceneBackground.LoopAnimTimer(Sender: TObject);
var
  BMP: TBitmap;
  BMPScale: Single;
  i: integer;
  X, y: Single;
  BubbleRadius: Single;
  PrevX, PrevY, PrevZ: Single;
begin
  if (IsPlaying <> tgamedata.DefaultGameData.IsPlaying) then
    InitGame;

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
        PrevX := BubbleField[i].X;
        BubbleField[i].X := BubbleField[i].X - SpeedX;
        if (BubbleField[i].X > CFieldSize) then
          while (BubbleField[i].X > CFieldSize) do
            BubbleField[i].X := BubbleField[i].X - 2 * CFieldSize
        else if (BubbleField[i].X < -CFieldSize) then
          while (BubbleField[i].X < -CFieldSize) do
            BubbleField[i].X := BubbleField[i].X + 2 * CFieldSize;
        PrevY := BubbleField[i].y;
        BubbleField[i].y := BubbleField[i].y - SpeedY;
        if (BubbleField[i].y > CFieldSize) then
          while (BubbleField[i].y > CFieldSize) do
            BubbleField[i].y := BubbleField[i].y - 2 * CFieldSize
        else if (BubbleField[i].y < -CFieldSize) then
          while (BubbleField[i].y < -CFieldSize) do
            BubbleField[i].y := BubbleField[i].y + 2 * CFieldSize;
        PrevZ := BubbleField[i].Z;
        BubbleField[i].Z := BubbleField[i].Z - SpeedZ;
        if (BubbleField[i].Z > CFieldSize) then
          while (BubbleField[i].Z > CFieldSize) do
            BubbleField[i].Z := BubbleField[i].Z - 2 * CFieldSize
        else if (BubbleField[i].Z < -CFieldSize) then
          while (BubbleField[i].Z < -CFieldSize) do
            BubbleField[i].Z := BubbleField[i].Z + 2 * CFieldSize;

        if (BubbleField[i].Z > 0) and (BubbleField[i].Z < CCircleDiameter) then
        begin
          X := CenterX + SpeedX + BubbleField[i].X / BubbleField[i].Z;
          // TODO : changer la distance = taille de chaque cellule ? / "* 5";
          y := CenterY + SpeedY - BubbleField[i].y / BubbleField[i].Z;
          // TODO : changer la distance = taille de chaque cellule ? / "* 5";
          if (X >= 0) and (X < width) and (y >= 0) and (y < height) then
          begin
            BubbleRadius := 3 * CCircleRadius / BubbleField[i].Z;
            BMP.canvas.FillEllipse(trectf.Create(X - BubbleRadius,
              y - BubbleRadius, X + BubbleRadius, y + BubbleRadius),
              1 - 0.7 / BubbleField[i].Z);
            // TODO : remplacer les ellipses par des images de bulles (TSVGBubbles)
          end;
        end
        else if tgamedata.DefaultGameData.IsPlaying and (PrevZ > 0) and
          (BubbleField[i].Z < 0) then
        begin
          // TODO : recalculer la position lors de l'impact en trouvant les coordonnées X,Y de traversée du plan de l'écran avec Z=0
          X := CenterX + SpeedX + PrevX;
          y := CenterY + SpeedY - PrevY;
          BubbleRadius := 3 * CCircleRadius; // z=0 au passage de l'écran
          if (sqrt(sqr(X - UserCircleCenterX) + sqr(y - UserCircleCenterY)) -
            BubbleRadius <= UserCircleRadius) then
          begin
            // choc => perte de vie
            tgamedata.DefaultGameData.NbLives :=
              tgamedata.DefaultGameData.NbLives - 1;
            if (tgamedata.DefaultGameData.NbLives < 1) then
            begin
              tgamedata.DefaultGameData.StopGame;
              tscene.current := tscenetype.GameOverLost;
            end;
          end
          else
          begin
            tgamedata.DefaultGameData.Score :=
              tgamedata.DefaultGameData.Score + 1;
            if (0 = tgamedata.DefaultGameData.Score mod (CPalierScorePourVie *
              tgamedata.DefaultGameData.Level)) then
              tgamedata.DefaultGameData.NbLives :=
                tgamedata.DefaultGameData.NbLives + 1;
          end;
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
  if SpeedZ < 20 then
    SpeedZ := SpeedZ * 1.1;
end;

procedure TSceneBackground.RefreshUserCircle;
begin
  UserCircle.width := CCircleDiameter * 1.5;
  UserCircle.height := CCircleDiameter * 1.5;
  UserCircleCenterX := UserCircle.Position.X + UserCircle.width / 2;
  UserCircleCenterY := UserCircle.Position.y + UserCircle.height / 2;
  UserCircleRadius := UserCircle.width / 2;
  UserCircle.visible := IsPlaying;
end;

procedure TSceneBackground.ShowScene;
begin
  inherited;
  SendToBack;

  imgBubbleField.parent := application.mainform;
  imgBubbleField.visible := true;
  self.visible := false;

  IsPlaying := false;
  InitGame;

  LoopAnim.interval := round(1000 / cfps);
  LoopAnim.Enabled := true;
end;

end.
