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
/// File last update : 2025-01-25T21:07:10.000+01:00
/// Signature : b2c5569f24b7e54773cc22ba97a515f4b045b574
/// ***************************************************************************
/// </summary>

unit cButtonIcon;

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
  _ButtonsAncestor,
  FMX.Objects;

type
{$SCOPEDENUMS ON}
  TBackgroundColor = (Green, Red);
  TIconType = (None, Cancel, Music, Ok, Pause, Sound);

  TButtonIcon = class(T__ButtonAncestor)
    rBackground: TRectangle;
    rIcon: TRectangle;
  private
    FBackgroundColor: TBackgroundColor;
    FIconType: TIconType;
    procedure SetBackgroundColor(const Value: TBackgroundColor);
    procedure SetIconType(const Value: TIconType);
  public
    constructor Create(AOwner: TComponent); override;
    property BackgroundColor: TBackgroundColor read FBackgroundColor
      write SetBackgroundColor;
    property IconType: TIconType read FIconType write SetIconType;
    procedure Repaint; override;

  end;

var
  ButtonIcon: TButtonIcon;

implementation

{$R *.fmx}

uses
  uSVGBitmapManager_InputPrompts,
  USVGAdobeStock;
{ TButtonIcon }

constructor TButtonIcon.Create(AOwner: TComponent);
begin
  inherited;
  FBackgroundColor := TBackgroundColor.Green;
  FIconType := TIconType.None;
end;

procedure TButtonIcon.Repaint;
begin
  if IsDown then
    rBackground.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.BtnOrange, rBackground.Width,
      rBackground.Height, rBackground.fill.bitmap.bitmap.BitmapScale))
  else if (BackgroundColor = TBackgroundColor.Green) then
    rBackground.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.BtnGreen, rBackground.Width,
      rBackground.Height, rBackground.fill.bitmap.bitmap.BitmapScale))
  else
    rBackground.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.BtnRed, rBackground.Width,
      rBackground.Height, rBackground.fill.bitmap.bitmap.BitmapScale));

  if (FIconType = TIconType.None) then
    rIcon.Visible := false
  else
  begin
    rIcon.Visible := true;
    case FIconType of
      TIconType.Cancel:
        rIcon.fill.bitmap.bitmap.Assign
          (getBitmapFromSVG(TSVGAdobeStockIndex.IconCancel, rIcon.Width,
          rIcon.Height, rIcon.fill.bitmap.bitmap.BitmapScale));
      TIconType.Music:
        rIcon.fill.bitmap.bitmap.Assign
          (getBitmapFromSVG(TSVGAdobeStockIndex.IconMusic, rIcon.Width,
          rIcon.Height, rIcon.fill.bitmap.bitmap.BitmapScale));
      TIconType.Ok:
        rIcon.fill.bitmap.bitmap.Assign
          (getBitmapFromSVG(TSVGAdobeStockIndex.IconOk, rIcon.Width,
          rIcon.Height, rIcon.fill.bitmap.bitmap.BitmapScale));
      TIconType.Pause:
        rIcon.fill.bitmap.bitmap.Assign
          (getBitmapFromSVG(TSVGAdobeStockIndex.IconPause, rIcon.Width,
          rIcon.Height, rIcon.fill.bitmap.bitmap.BitmapScale));
      TIconType.Sound:
        rIcon.fill.bitmap.bitmap.Assign
          (getBitmapFromSVG(TSVGAdobeStockIndex.IconSound, rIcon.Width,
          rIcon.Height, rIcon.fill.bitmap.bitmap.BitmapScale));
    else
      raise Exception.Create('Unknown Icon Type value for the button "' +
        Name + '".');
    end;
  end;
end;

procedure TButtonIcon.SetBackgroundColor(const Value: TBackgroundColor);
begin
  if (FBackgroundColor <> Value) then
  begin
    FBackgroundColor := Value;
    Repaint;
  end;
end;

procedure TButtonIcon.SetIconType(const Value: TIconType);
begin
  if (FIconType <> Value) then
  begin
    FIconType := Value;
    Repaint;
  end;
end;

end.
