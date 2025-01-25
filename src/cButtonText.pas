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
/// File last update : 2025-01-25T22:46:18.000+01:00
/// Signature : a0848040c9005b7c90a2d48507c04037e50339a8
/// ***************************************************************************
/// </summary>

unit cButtonText;

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
  Olf.FMX.TextImageFrame,
  FMX.Objects,
  FMX.Layouts;

type
  TButtonText = class(T__ButtonAncestor)
    rBackground: TRectangle;
    tiText: TOlfFMXTextImageFrame;
    rFocused: TRectangle;
    lText: TLayout;
  private
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
  public
    procedure Repaint; override;
  end;

implementation

{$R *.fmx}

uses
  USVGAdobeStock,
  uSVGBitmapManager_InputPrompts,
  udmAdobeStock_497062500;

function TButtonText.GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
  AChar: char): integer;
begin
  if (AChar = 'ç') then
    result := Sender.getImageIndexOfChar('C')
  else if (AChar = 'é') then
    result := Sender.getImageIndexOfChar('E')
  else
    result := Sender.getImageIndexOfChar(UpperCase(AChar));
end;

procedure TButtonText.Repaint;
begin
  if IsDown then
    rBackground.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.ButtonOn, rBackground.Width,
      rBackground.Height, rBackground.fill.bitmap.bitmap.BitmapScale))
  else
    rBackground.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.ButtonOff, rBackground.Width,
      rBackground.Height, rBackground.fill.bitmap.bitmap.BitmapScale));
  tiText.Font := dmAdobeStock_497062500.ImageList;
  tiText.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  tiText.Text := Text;
  if IsFocused then
  begin
    rFocused.fill.bitmap.bitmap.Assign
      (getBitmapFromSVG(TSVGAdobeStockIndex.LightningBlue, rFocused.Width,
      rFocused.Height, rFocused.fill.bitmap.bitmap.BitmapScale));
    rFocused.Visible := true;
  end
  else
    rFocused.Visible := false;
end;

end.
