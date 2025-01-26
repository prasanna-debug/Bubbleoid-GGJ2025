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
/// File last update : 2025-01-26T14:10:50.000+01:00
/// Signature : e0dda6470a3d399806650098a342d19af5171b54
/// ***************************************************************************
/// </summary>

unit uSceneCredits;

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
  TSceneCredits = class(T__SceneAncestor)
  private
  public
    procedure ShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  cDialogBox,
  uTxtAboutDescription,
  uTxtAboutLicense,
  uConsts,
  uConfig,
  System.Messaging,
  uScene;

{ TSceneCredits }

procedure TSceneCredits.ShowScene;
begin
  inherited;
  TDialogBox.Execute(self, CAboutGameTitle,
    GetTxtAboutDescription(tconfig.Current.Language).trim + sLineBreak +
    sLineBreak + '**********' + sLineBreak + '* License' + sLineBreak +
    sLineBreak + GetTxtAboutLicense(tconfig.Current.Language).trim + sLineBreak
    + sLineBreak + application.MainForm.Caption + ' ' + CAboutCopyright +
    sLineBreak, TSceneType.Home);
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneCredits;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Credits) then
    begin
      NewScene := TSceneCredits.Create(application.MainForm);
      NewScene.Parent := application.MainForm;
      TScene.RegisterScene(TSceneType.Credits, NewScene);
    end;
  end);

end.
