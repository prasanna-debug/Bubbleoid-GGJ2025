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
/// File last update : 2025-01-26T13:44:26.000+01:00
/// Signature : 0f1d2d6c51b1a4ac6abe7ab1f2532c74e12425f0
/// ***************************************************************************
/// </summary>

unit uSceneHome;

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
  FMX.Layouts,
  _ButtonsAncestor,
  cButtonText,
  Olf.FMX.TextImageFrame;

type
  TSceneHome = class(T__SceneAncestor)
    lTitle: TLayout;
    tiTitle: TOlfFMXTextImageFrame;
    btnNewGame: TButtonText;
    btnContinue: TButtonText;
    btnOptions: TButtonText;
    btnHallOfFame: TButtonText;
    btnCredits: TButtonText;
    VertScrollBox1: TVertScrollBox;
    MenuFlowLayout: TFlowLayout;
    btnQuit: TButtonText;
    procedure FrameResized(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnNewGameClick(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
  private
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
    procedure ResizeMenuFlowLayout;
  public
    procedure HideScene; override;
    procedure ShowScene; override;
    procedure TranslateTexts(const Language: string); override;
  end;

implementation

{$R *.fmx}

uses
  uConfig,
  uScene,
  System.Messaging,
  uConsts,
  uUIElements,
  udmAdobeStock_244522135_244522157,
  uGameData;

{ TSceneHome }

procedure TSceneHome.btnContinueClick(Sender: TObject);
begin
  TGameData.DefaultGameData.ContinueGame;
  TScene.Current := TSceneType.Game;
end;

procedure TSceneHome.btnCreditsClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Credits;
end;

procedure TSceneHome.btnHallOfFameClick(Sender: TObject);
begin
  TScene.Current := TSceneType.HallOfFame;
end;

procedure TSceneHome.btnNewGameClick(Sender: TObject);
begin
  TGameData.DefaultGameData.StartANewGame;
  TScene.Current := TSceneType.Game;
end;

procedure TSceneHome.btnOptionsClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Options;
end;

procedure TSceneHome.btnQuitClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Exit;
end;

procedure TSceneHome.FrameResized(Sender: TObject);
begin
  ResizeMenuFlowLayout;
end;

function TSceneHome.GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
  AChar: char): integer;
begin
  result := Sender.getImageIndexOfChar(UpperCase(AChar));
end;

procedure TSceneHome.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TSceneHome.ResizeMenuFlowLayout;
var
  y: single;
  i: integer;
begin
  y := 0;
  for i := 0 to MenuFlowLayout.ControlsCount - 1 do
    if MenuFlowLayout.Controls[i].Visible and
      (MenuFlowLayout.Controls[i].Position.y + MenuFlowLayout.Controls[i].Height
      + MenuFlowLayout.Controls[i].margins.Bottom > y) then
      y := MenuFlowLayout.Controls[i].Position.y + MenuFlowLayout.Controls[i]
        .Height + MenuFlowLayout.Controls[i].margins.Bottom;
  MenuFlowLayout.Height := y;
end;

procedure TSceneHome.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnNewGame, nil, btnCredits, btnCredits,
    nil, true);
  btnContinue.Visible := false;
  btnOptions.Visible := false;
  btnHallOfFame.Visible := false;
{$IF Defined(IOS) or Defined(ANDROID)}
  btnQuit.Visible := false;
{$ENDIF}
  if btnQuit.Visible then
  begin
    TUIItemsList.Current.AddControl(btnCredits, btnNewGame, btnQuit, btnQuit,
      btnNewGame);
    TUIItemsList.Current.AddControl(btnQuit, btnCredits, nil, nil, btnCredits,
      false, true);
  end
  else
    TUIItemsList.Current.AddControl(btnCredits, btnNewGame, nil, nil,
      btnNewGame);

  tiTitle.font := dmAdobeStock_244522135_244522157.ImageList;
  tiTitle.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  tiTitle.Text := CAboutGameTitle;

  ResizeMenuFlowLayout;
end;

procedure TSceneHome.TranslateTexts(const Language: string);
begin
  inherited;
  if (Language = 'fr') then
  begin
    btnNewGame.Text := 'Jouer';
    btnContinue.Text := 'Reprendre';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Scores';
    btnCredits.Text := 'Crédits';
    btnQuit.Text := 'Quitter';
  end
  else
  begin
    btnNewGame.Text := 'Play';
    btnContinue.Text := 'Continue';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Scores';
    btnCredits.Text := 'Credits';
    btnQuit.Text := 'Quit';
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneHome;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Home) then
    begin
      NewScene := TSceneHome.Create(application.mainform);
      NewScene.Parent := application.mainform;
      TScene.RegisterScene(TSceneType.Home, NewScene);
    end;
  end);

end.
