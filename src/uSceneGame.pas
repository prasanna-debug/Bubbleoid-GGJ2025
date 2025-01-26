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
/// File last update : 2025-01-26T19:39:02.000+01:00
/// Signature : a44e6ca27a14a3b19a6cd4d70d1cf26b0af6f9b7
/// ***************************************************************************
/// </summary>

unit uSceneGame;

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
  System.Messaging,
  FMX.Controls.Presentation,
  Olf.FMX.TextImageFrame,
  FMX.Layouts;

type
  TSceneGame = class(T__SceneAncestor)
    UpdateScore: TTimer;
    lScore: TLayout;
    tiScore: TOlfFMXTextImageFrame;
    flNbLives: TFlowLayout;
    rLives: TRectangle;
    rDeaths: TRectangle;
    procedure FrameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure UpdateScoreTimer(Sender: TObject);
  private
    FNbLives: int64;
    FNbLivesMax: int64;
    FScore: int64;
    procedure SetScore(const Value: int64);
  protected
    procedure DoNbLivesChanged(const Sender: TObject; const Msg: TMessage);
    procedure ShowNbLives;
    procedure FlashRect(const Color: TAlphaColor);
  public
    property Score: int64 read FScore write SetScore;
    procedure ShowScene; override;
    procedure HideScene; override;
  end;

  // TODO : ajouter affichage du score
implementation

{$R *.fmx}

uses
  uConsts,
  uScene,
  uUIElements,
  uGameData,
  uSVGBitmapManager_InputPrompts,
  USVGAdobeStock,
  udmAdobeStock_244522135_244522157;

{ TSceneGame }

procedure TSceneGame.DoNbLivesChanged(const Sender: TObject;
  const Msg: TMessage);
begin
  if not assigned(self) then
    exit;

  if assigned(Msg) and (Msg is TNbLivesChangedMessage) then
    ShowNbLives;
end;

procedure TSceneGame.FlashRect(const Color: TAlphaColor);
var
  r: TRectangle;
begin
  r := TRectangle.Create(self);
  r.parent := self;
  r.Stroke.Kind := TBrushKind.None;
  r.Fill.Color := Color;
  r.Opacity := 0.3;
  r.Align := TAlignLayout.Contents;
  tthread.CreateAnonymousThread(
    procedure
    begin
      sleep(100);
      tthread.queue(nil,
        procedure
        begin
          r.free;
        end);
    end).start;
end;

procedure TSceneGame.FrameKeyDown(Sender: TObject; var Key: Word;
var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkLeft then
  begin
    Key := 0;
    SpeedX := SpeedX - speedz;
  end
  else if Key = vkRight then
  begin
    Key := 0;
    SpeedX := SpeedX + speedz;
  end
  else if Key = vkup then
  begin
    Key := 0;
    SpeedY := SpeedY - speedz;
  end
  else if Key = vkDown then
  begin
    Key := 0;
    SpeedY := SpeedY + speedz;
  end
  else if (Key = vkEscape) or (Key = vkHardwareBack) then
  begin
    Key := 0;
    tgamedata.DefaultGameData.StopGame;
    tscene.Current := tscenetype.GameOverLost;
  end;
end;

procedure TSceneGame.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
  UpdateScore.Enabled := false;
  TMessageManager.DefaultManager.Unsubscribe(TNbLivesChangedMessage,
    DoNbLivesChanged, true);
end;

procedure TSceneGame.SetScore(const Value: int64);
begin
  FScore := Value;
  tiScore.text := Score.ToString;
end;

procedure TSceneGame.ShowNbLives;
var
  GDNbLives: int64;
  w: single;
begin
  GDNbLives := tgamedata.DefaultGameData.NbLives;

  w := GDNbLives * rLives.height;
  if w < width then
    rLives.width := w;
  w := (FNbLivesMax - GDNbLives) * rDeaths.height;
  if w < width then
    rDeaths.width := w;

  if (GDNbLives < FNbLives) then
  begin
    // TODO : jouer un son de perte d'une vie
    FlashRect(talphacolors.red);
  end
  else if (GDNbLives > FNbLives) then
  begin
    if (GDNbLives > FNbLivesMax) then
      FNbLivesMax := GDNbLives;

    // TODO : jouer un son de gain d'une nouvelle vie
    FlashRect(talphacolors.green);
  end;
  FNbLives := GDNbLives;
end;

procedure TSceneGame.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;

  rLives.Fill.Bitmap.Bitmap.Assign(getBitmapFromSVG(TSVGAdobeStockIndex.Heart,
    rLives.height, rLives.height, rLives.Fill.Bitmap.Bitmap.BitmapScale));
  rDeaths.Fill.Bitmap.Bitmap.Assign
    (getBitmapFromSVG(TSVGAdobeStockIndex.HeartBroken, rLives.height,
    rLives.height, rLives.Fill.Bitmap.Bitmap.BitmapScale));
  FNbLives := tgamedata.DefaultGameData.NbLives;
  FNbLivesMax := CDefaultNbLives;
  // TODO : ajouter NbLivesMax sur GameData dans le cas de Pause/Resume d'une partie
  ShowNbLives;
  TMessageManager.DefaultManager.SubscribeToMessage(TNbLivesChangedMessage,
    DoNbLivesChanged);

  tiScore.Font := dmAdobeStock_244522135_244522157.ImageList;
  Score := 0;
  UpdateScore.Enabled := true;
end;

procedure TSceneGame.UpdateScoreTimer(Sender: TObject);
var
  GDScore: int64;
begin
  GDScore := tgamedata.DefaultGameData.Score;
  if Score < GDScore then
    Score := Score + 1
  else if Score > GDScore then
    Score := Score - 1;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneGame;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = tscenetype.Game) then
    begin
      NewScene := TSceneGame.Create(application.mainform);
      NewScene.parent := application.mainform;
      tscene.RegisterScene(tscenetype.Game, NewScene);
    end;
  end);

end.
