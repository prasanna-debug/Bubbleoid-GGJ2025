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
/// File last update : 2025-01-26T14:24:30.000+01:00
/// Signature : f37e31059c34b86c421931a62ace5c058d4d3297
/// ***************************************************************************
/// </summary>

unit uSceneGameOverLost;

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
  _ScenesAncestor;

type
  TSceneGameOverLost = class(T__SceneAncestor)
  private
  public
    procedure ShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  cDialogBox,
  uConsts,
  uConfig,
  System.Messaging,
  uScene,
  uGameData;

{ TSceneGameOverLost }

procedure TSceneGameOverLost.ShowScene;
var
  Title, Text: string;
begin
  inherited;
  if tconfig.Current.Language = 'fr' then
  begin
    Title := 'Fin de partie';
    Text := 'Votre partie s''arrête sur un score de ' +
      tgamedata.DefaultGameData.Score.ToString + '.' + sLineBreak + sLineBreak +
      'Pouvez-vous faire mieux ?';
  end
  else
  begin
    Title := 'Game Over';
    Text := 'Your game ends with a score of ' +
      tgamedata.DefaultGameData.Score.ToString + '.' + sLineBreak + sLineBreak +
      'Can you do better ?';
  end;
  TDialogBox.Execute(self, Title, Text, TSceneType.home);
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneGameOverLost;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.GameOverLost) then
    begin
      NewScene := TSceneGameOverLost.Create(application.MainForm);
      NewScene.Parent := application.MainForm;
      TScene.RegisterScene(TSceneType.GameOverLost, NewScene);
    end;
  end);

end.
