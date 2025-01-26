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
/// File last update : 2025-01-26T15:04:54.000+01:00
/// Signature : 7b81d7b971c14d999f0b0aaf26e74a2463fd6d97
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
  private
  protected
  public
    StarField: TStarsList;
    SpeedX, SpeedY, SpeedZ: Single;
    procedure ShowScene; override;
    procedure HideScene; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

constructor TSceneBackground.Create(AOwner: TComponent);
begin
  inherited;
  // TODO : transférer les variables dans un TGameData personnalisé
  StarField := TStarsList.Create(5000, 10000, 10000, 10000);
  SpeedX := 0;
  SpeedY := 0;
  SpeedZ := 1;
end;

destructor TSceneBackground.Destroy;
begin
  StarField.free;
  inherited;
end;

procedure TSceneBackground.HideScene;
begin
  inherited;

  LoopAnim.Enabled := false;
end;

procedure TSceneBackground.LoopAnimTimer(Sender: TObject);
var
  BMP: TBitmap;
  i: integer;
  X, Y: integer;
  CenterX, CenterY: integer;
const
  CircleDiameter = 256;
  CircleRadius = CircleDiameter / 2;
begin
  StarField.Move(round(SpeedX), round(SpeedY), round(SpeedZ));
  // création d'un bitmap
  BMP := TBitmap.Create(round(width), round(height));
  try
    BMP.Clear(talphacolors.Darkblue);
    // TODO : don't forget the BitmapScale
    CenterX := round((BMP.width / 2) + SpeedX);
    CenterY := round((BMP.height / 2) - SpeedY);
    BMP.canvas.BeginScene;
    try
      // parcourt de la liste des étoiles pour affichage de celles qui sont devant nous
      for i := 0 to StarField.count - 1 do
        if (StarField[i].z > 0) and (StarField[i].z < CircleDiameter) then
        begin
          X := CenterX + round(StarField[i].X / StarField[i].z);
          Y := CenterY - round(StarField[i].Y / StarField[i].z);
          if (X >= 0) and (X < BMP.width) and (Y >= 0) and (Y < BMP.height) then
          // TODO : tester les angles de la bulle plutôt que son centre
          begin
            BMP.canvas.Fill.Color := talphacolors.White;
            BMP.canvas.stroke.Kind := TBrushKind.None;
            BMP.canvas.FillEllipse
              (trectf.Create(X - CircleRadius / StarField[i].z,
              Y - CircleRadius / StarField[i].z, X + CircleRadius / StarField[i]
              .z, Y + CircleRadius / StarField[i].z), 1 - 0.7 / StarField[i].z);
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
  if SpeedZ < 10 then
    SpeedZ := SpeedZ * 1.1;
end;

procedure TSceneBackground.ShowScene;
begin
  inherited;
  SendToBack;

  LoopAnim.Enabled := true;
end;

end.
