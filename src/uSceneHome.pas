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
/// File last update : 2025-01-25T22:55:22.000+01:00
/// Signature : b69e26adbb9979e6e9936112a9c473ffddef9f37
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
    FlowLayout1: TFlowLayout;
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
  udmAdobeStock_244522135_244522157;

{ TSceneHome }

procedure TSceneHome.btnContinueClick(Sender: TObject);
begin
  // TODO : à compléter
  // TScene.Current:=TSceneType.Game;
end;

procedure TSceneHome.btnCreditsClick(Sender: TObject);
begin
  // TODO : à compléter
  // TScene.Current:=TSceneType.Game;
end;

procedure TSceneHome.btnHallOfFameClick(Sender: TObject);
begin
  // TODO : à compléter
  // TScene.Current:=TSceneType.Game;
end;

procedure TSceneHome.btnNewGameClick(Sender: TObject);
begin
  // TODO : à compléter
  // TScene.Current:=TSceneType.Game;
end;

procedure TSceneHome.btnOptionsClick(Sender: TObject);
begin
  // TODO : à compléter
  // TScene.Current:=TSceneType.Game;
end;

procedure TSceneHome.btnQuitClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Exit;
end;

procedure TSceneHome.FrameResized(Sender: TObject);
begin
  // TODO : recalculer hauteur du TFlowLayout contenant les boutons (soit les parcourrir tous, soit regarder le dernier)
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

procedure TSceneHome.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(btnNewGame, nil, btnCredits, btnCredits,
    nil, true);
  btnContinue.Visible := false;
  btnOptions.Visible := false;
  btnHallOfFame.Visible := false;
  TUIItemsList.Current.AddControl(btnCredits, btnNewGame, btnQuit, btnQuit,
    btnNewGame);
  TUIItemsList.Current.AddControl(btnQuit, btnCredits, nil, nil, btnCredits,
    false, true);

  tiTitle.font := dmAdobeStock_244522135_244522157.ImageList;
  tiTitle.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  tiTitle.Text := CAboutGameTitle;
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
