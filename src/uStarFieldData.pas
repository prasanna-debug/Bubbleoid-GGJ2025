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
/// File last update : 2025-01-26T16:04:12.000+01:00
/// Signature : 719a38c0cab5e82b6f7a7f1c233c3fdbaa925bb9
/// ***************************************************************************
/// </summary>

unit uStarFieldData;

interface

uses
  System.Generics.Collections;

type
  TStar = class(TObject)
  private
    FZ: single;
    FX: single;
    FY: single;
    procedure SetX(const Value: single);
    procedure SetY(const Value: single);
    procedure SetZ(const Value: single);
  protected
  public
    property X: single read FX write SetX;
    property Y: single read FY write SetY;
    property Z: single read FZ write SetZ;
    class function GetNewStar(const MaxX, MaxY, MaxZ: integer): TStar;
  end;

  TStarsList = class(TObjectList<TStar>)
  private
    FMaxX, FMaxY, FMaxZ: integer;
  protected
  public
    property MaxX: integer read FMaxX;
    property MaxY: integer read FMaxY;
    property MaxZ: integer read FMaxZ;
    constructor Create(const ANbStars: integer = 100;
      const AMaxX: integer = 500; const AMaxY: integer = 500;
      const AMaxZ: integer = 500); virtual;
    destructor Destroy; override;
    procedure Move(VX, VY, VZ: single);
  end;

implementation

{ TStar }

class function TStar.GetNewStar(const MaxX, MaxY, MaxZ: integer): TStar;
begin
  result := TStar.Create;
  result.X := random(2 * MaxX) - MaxX;
  result.Y := random(2 * MaxY) - MaxY;
  result.Z := random(2 * MaxZ) - MaxZ;
end;

procedure TStar.SetX(const Value: single);
begin
  FX := Value;
end;

procedure TStar.SetY(const Value: single);
begin
  FY := Value;
end;

procedure TStar.SetZ(const Value: single);
begin
  FZ := Value;
end;

{ TStarsList }

constructor TStarsList.Create(const ANbStars, AMaxX, AMaxY, AMaxZ: integer);
var
  i: integer;
begin
  inherited Create;

  FMaxX := AMaxX;
  FMaxY := AMaxY;
  FMaxZ := AMaxZ;

  for i := 1 to ANbStars do
    self.Add(TStar.GetNewStar(FMaxX, FMaxY, FMaxZ));
end;

destructor TStarsList.Destroy;
begin
  // TODO : à compléter ou supprimer
  inherited;
end;

procedure TStarsList.Move(VX, VY, VZ: single);
var
  i: integer;
begin
  for i := 0 to self.Count - 1 do
  begin
    self[i].X := self[i].X - VX;
    while (self[i].X > FMaxX) do
      self[i].X := self[i].X - 2 * FMaxX;
    while (self[i].X < -FMaxX) do
      self[i].X := self[i].X + 2 * FMaxX;
    self[i].Y := self[i].Y - VY;
    while (self[i].Y > FMaxY) do
      self[i].Y := self[i].Y - 2 * FMaxY;
    while (self[i].Y < -FMaxY) do
      self[i].Y := self[i].Y + 2 * FMaxY;
    self[i].Z := self[i].Z - VZ;
    while (self[i].Z > FMaxZ) do
      self[i].Z := self[i].Z - 2 * FMaxZ;
    while (self[i].Z < -FMaxZ) do
      self[i].Z := self[i].Z + 2 * FMaxZ;
  end;
end;

end.
