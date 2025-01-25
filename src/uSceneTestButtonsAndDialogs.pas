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
/// File last update : 2025-01-25T19:37:06.000+01:00
/// Signature : a50975a8ef95170dcecf4f8b7a51f115f52547c5
/// ***************************************************************************
/// </summary>

unit uSceneTestButtonsAndDialogs;

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
  _ButtonsAncestor,
  cButtonText;

type
  TSceneTestButtonsAndDialogs = class(T__SceneAncestor)
    ButtonText1: TButtonText;
    ButtonText2: TButtonText;
    procedure ButtonText1Click(Sender: TObject);
    procedure ButtonText2Click(Sender: TObject);
  private
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
  end;

var
  SceneTestButtonsAndDialogs: TSceneTestButtonsAndDialogs;

implementation

{$R *.fmx}

uses
  uConfig,
  uScene,
  System.Messaging,
  uConsts,
  uUIElements;

procedure TSceneTestButtonsAndDialogs.ButtonText1Click(Sender: TObject);
begin
  TConfig.Current.Language := 'fr';
end;

procedure TSceneTestButtonsAndDialogs.ButtonText2Click(Sender: TObject);
begin
  TConfig.Current.Language := 'en';
end;

procedure TSceneTestButtonsAndDialogs.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TSceneTestButtonsAndDialogs.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddControl(ButtonText1, nil, nil, ButtonText2,
    nil, true);
  TUIItemsList.Current.AddControl(ButtonText2, ButtonText1, nil, nil, nil);
  TUIItemsList.Current.AddQuit;
end;

procedure TSceneTestButtonsAndDialogs.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    ButtonText1.Text := 'En français';
    ButtonText2.Text := 'En anglais';
  end
  else
  begin
    ButtonText1.Text := 'In French';
    ButtonText2.Text := 'In English';
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneTestButtonsAndDialogs;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.TestButtonsAndDialogs) then
    begin
      NewScene := TSceneTestButtonsAndDialogs.Create(application.mainform);
      NewScene.Parent := application.mainform;
      tscene.RegisterScene(TSceneType.TestButtonsAndDialogs, NewScene);
    end;
  end);

end.
