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
/// File last update : 2025-01-25T16:07:56.000+01:00
/// Signature : bdd32eea092c0d76a0be34da563a0b0b3288c0ba
/// ***************************************************************************
/// </summary>

unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  uStarFieldData,
  FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    Image1: TImage;
    LoopAnim: TTimer;
    procedure LoopAnimTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
  private
  public
    StarField: TStarsList;
    SpeedX, SpeedY, SpeedZ: Single;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  StarField := TStarsList.Create(5000, 10000, 10000, 10000);
  SpeedX := 0;
  SpeedY := 0;
  SpeedZ := 1;
end;

destructor TfrmMain.Destroy;
begin
  StarField.free;
  inherited;
end;

procedure TfrmMain.FormHide(Sender: TObject);
begin
  LoopAnim.Enabled := false;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkLeft then
  begin
    Key := 0;
    SpeedX := SpeedX - 1;
  end
  else if Key = vkRight then
  begin
    Key := 0;
    SpeedX := SpeedX + 1;
  end
  else if Key = vkup then
  begin
    Key := 0;
    SpeedY := SpeedY - 1;
  end
  else if Key = vkDown then
  begin
    Key := 0;
    SpeedY := SpeedY + 1;
  end
  else if (Key = vkEscape) or (Key = vkHardwareBack) then
  begin
    Key := 0;
    close;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoopAnim.Enabled := true;
end;

procedure TfrmMain.LoopAnimTimer(Sender: TObject);
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
  BMP := TBitmap.Create(1920, 1080);
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
    Image1.Bitmap.Assign(BMP);
  finally
    BMP.free;
  end;
  if SpeedZ < 10 then
    SpeedZ := SpeedZ * 1.1;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
