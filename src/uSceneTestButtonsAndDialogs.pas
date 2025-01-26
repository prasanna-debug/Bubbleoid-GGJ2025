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
/// File last update : 2025-01-26T12:12:42.000+01:00
/// Signature : 68fc6322c1c20244742ebf92c5bd98e2066fe11b
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
  cButtonText,
  cButtonIcon,
  cDialogBox;

type
  TSceneTestButtonsAndDialogs = class(T__SceneAncestor)
    ButtonText1: TButtonText;
    ButtonText2: TButtonText;
    ButtonIcon1: TButtonIcon;
    ButtonIcon2: TButtonIcon;
    ButtonIcon3: TButtonIcon;
    ButtonIcon4: TButtonIcon;
    ButtonIcon5: TButtonIcon;
    procedure ButtonText1Click(Sender: TObject);
    procedure ButtonText2Click(Sender: TObject);
    procedure ButtonIcon3Click(Sender: TObject);
  private
    DialogBoxTitle, DialogBoxText: string;
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
  end;

implementation

{$R *.fmx}

uses
  uConfig,
  uScene,
  System.Messaging,
  uConsts,
  uUIElements;

procedure TSceneTestButtonsAndDialogs.ButtonIcon3Click(Sender: TObject);
begin
  TDialogBox.Execute(self, DialogBoxTitle, DialogBoxText);
end;

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

  ButtonIcon1.BackgroundColor := TBackgroundColor.Green;
  ButtonIcon1.IconType := TIconType.Ok;
  ButtonIcon2.BackgroundColor := TBackgroundColor.Red;
  ButtonIcon2.IconType := TIconType.cancel;
  ButtonIcon3.BackgroundColor := TBackgroundColor.Green;
  ButtonIcon3.IconType := TIconType.Music;
  ButtonIcon4.BackgroundColor := TBackgroundColor.Red;
  ButtonIcon4.IconType := TIconType.Pause;
  ButtonIcon5.BackgroundColor := TBackgroundColor.Green;
  ButtonIcon5.IconType := TIconType.Sound;
end;

procedure TSceneTestButtonsAndDialogs.TranslateTexts(const Language: string);
begin
  inherited;
  if Language = 'fr' then
  begin
    ButtonText1.Text := 'En français';
    ButtonText2.Text := 'En anglais';
    DialogBoxTitle := 'Ma Boite De Dialogue';
    DialogBoxText := 'coucou c''est moi';
  end
  else
  begin
    ButtonText1.Text := 'In French';
    ButtonText2.Text := 'In English';
    DialogBoxTitle := 'My Dialog Box';
    DialogBoxText := 'hello it''s me';
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
