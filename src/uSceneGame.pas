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
/// File last update : 2025-01-26T20:06:32.000+01:00
/// Signature : 18e4e709c29db7c2737f84ab6defe5c8c4a37435
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
  FMX.Layouts,
  _ButtonsAncestor,
  cButtonIcon,
  Gamolf.RTL.Joystick;

type
  TSceneGame = class(T__SceneAncestor)
    UpdateScore: TTimer;
    lScore: TLayout;
    tiScore: TOlfFMXTextImageFrame;
    flNbLives: TFlowLayout;
    rLives: TRectangle;
    rDeaths: TRectangle;
    Layout1: TLayout;
    lRightButtons: TLayout;
    btnPause: TButtonIcon;
    DGEGamepadManager1: TDGEGamepadManager;
    procedure FrameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure UpdateScoreTimer(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure DGEGamepadManager1AxesChange(const GamepadID: Integer;
      const Axe: TJoystickAxes; const Value: Single);
    procedure DGEGamepadManager1DirectionPadChange(const GamepadID: Integer;
      const Value: TJoystickDPad);
  private
    FNbLives: int64;
    FNbLivesMax: int64;
    FScore: int64;
    procedure SetScore(const Value: int64);
    procedure GoToLeft;
    procedure GoToRight;
    procedure GoToUp;
    procedure GoToDown;
  protected
    procedure DoNbLivesChanged(const Sender: TObject; const Msg: TMessage);
    procedure ShowNbLives;
    procedure FlashRect(const Color: TAlphaColor);
  public
    property Score: int64 read FScore write SetScore;
    procedure ShowScene; override;
    procedure HideScene; override;
  end;

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

procedure TSceneGame.btnPauseClick(Sender: TObject);
begin
  TGameData.DefaultGameData.StopGame;
  TScene.Current := TSceneType.GameOverLost;
  // TODO : à remplacer par une mise en pause et retour à l'écran d'accueil
end;

procedure TSceneGame.DGEGamepadManager1AxesChange(const GamepadID: Integer;
  const Axe: TJoystickAxes; const Value: Single);
begin
  // TODO : à compléter
end;

procedure TSceneGame.DGEGamepadManager1DirectionPadChange(const GamepadID
  : Integer; const Value: TJoystickDPad);
begin
  if Value = TJoystickDPad.Top then
    GoToUp
  else if Value = TJoystickDPad.Right then
    GoToRight
  else if Value = TJoystickDPad.Bottom then
    GoToDown
  else if Value = TJoystickDPad.Left then
    GoToLeft;
end;

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
  r.HitTest := false;
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
    GoToLeft;
  end
  else if Key = vkRight then
  begin
    Key := 0;
    GoToRight;
  end
  else if Key = vkup then
  begin
    Key := 0;
    GoToUp;
  end
  else if Key = vkDown then
  begin
    Key := 0;
    GoToDown;
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

procedure TSceneGame.GoToDown;
begin
  SpeedY := SpeedY - speedz;
end;

procedure TSceneGame.GoToUp;
begin
  SpeedY := SpeedY + speedz;
end;

procedure TSceneGame.GoToRight;
begin
  SpeedX := SpeedX - speedz;
end;

procedure TSceneGame.GoToLeft;
begin
  SpeedX := SpeedX + speedz;
end;

procedure TSceneGame.SetScore(const Value: int64);
begin
  FScore := Value;
  tiScore.text := Score.ToString;
end;

procedure TSceneGame.ShowNbLives;
var
  GDNbLives: int64;
  w: Single;
begin
  GDNbLives := TGameData.DefaultGameData.NbLives;

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
  FNbLives := TGameData.DefaultGameData.NbLives;
  FNbLivesMax := CDefaultNbLives;
  // TODO : ajouter NbLivesMax sur GameData dans le cas de Pause/Resume d'une partie
  ShowNbLives;
  TMessageManager.DefaultManager.SubscribeToMessage(TNbLivesChangedMessage,
    DoNbLivesChanged);

  tiScore.Font := dmAdobeStock_244522135_244522157.ImageList;
  Score := 0;
  UpdateScore.Enabled := true;

  btnPause.IconType := TIconType.Pause;
  btnPause.BackgroundColor := TBackgroundColor.green;
  TUIItemsList.Current.AddControl(btnPause, nil, nil, nil, nil, false, true);
end;

procedure TSceneGame.UpdateScoreTimer(Sender: TObject);
var
  GDScore: int64;
begin
  GDScore := TGameData.DefaultGameData.Score;
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
      ((Msg as TSceneFactory).SceneType = TSceneType.Game) then
    begin
      NewScene := TSceneGame.Create(application.mainform);
      NewScene.parent := application.mainform;
      TScene.RegisterScene(TSceneType.Game, NewScene);
    end;
  end);

end.
