﻿/// <summary>
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
/// File last update : 2025-01-26T17:49:04.000+01:00
/// Signature : 0586b3aec0b7be295e61861f4b7a447d1afcb415
/// ***************************************************************************
/// </summary>

program Bubbleoid;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  fMain in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\fMain.pas' {frmMain},
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas',
  uConsts in 'uConsts.pas',
  Olf.RTL.Language in '..\lib-externes\librairies\src\Olf.RTL.Language.pas',
  Olf.RTL.CryptDecrypt in '..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  Olf.Skia.SVGToBitmap in '..\lib-externes\librairies\src\Olf.Skia.SVGToBitmap.pas',
  uDMAboutBox in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMAboutBox.pas' {AboutBox: TDataModule},
  uDMAboutBoxLogoStorrage in 'uDMAboutBoxLogoStorrage.pas' {dmAboutBoxLogo: TDataModule},
  uTxtAboutLicense in 'uTxtAboutLicense.pas',
  uTxtAboutDescription in 'uTxtAboutDescription.pas',
  Gamolf.FMX.HelpBar in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.HelpBar.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.GamepadDetected in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.GamepadDetected.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Helpers in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Helpers.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Scores.pas',
  Gamolf.RTL.UIElements in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.UIElements.pas',
  iOSapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  uTranslate in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uTranslate.pas',
  uConfig in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uConfig.pas',
  _ScenesAncestor in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\_ScenesAncestor.pas' {__SceneAncestor: TFrame},
  uScene in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uScene.pas',
  uUIElements in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uUIElements.pas',
  uGameData in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uGameData.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  Olf.RTL.Maths.Conversions in '..\lib-externes\librairies\src\Olf.RTL.Maths.Conversions.pas',
  uBackgroundMusic in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uBackgroundMusic.pas',
  uSoundEffects in 'uSoundEffects.pas',
  USVGInputPrompts in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\assets\kenney_nl\InputPrompts\USVGInputPrompts.pas',
  uDMGameControllerCenter in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMGameControllerCenter.pas' {DMGameControllerCenter: TDataModule},
  uSVGBitmapManager_InputPrompts in 'uSVGBitmapManager_InputPrompts.pas',
  uDMHelpBarManager in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMHelpBarManager.pas' {HelpBarManager: TDataModule},
  _ButtonsAncestor in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\_ButtonsAncestor.pas' {__ButtonAncestor: TFrame},
  uSceneBackground in 'uSceneBackground.pas' {SceneBackground: TFrame},
  cButtonText in 'cButtonText.pas' {ButtonText: TFrame},
  USVGBubbleFont in '..\_PRIVATE\assets\AdobeStock\AdobeStock_244522135_244522157\USVGBubbleFont.pas',
  udmAdobeStock_497062500 in '..\_PRIVATE\assets\AdobeStock\AdobeStock_497062500\udmAdobeStock_497062500.pas' {dmAdobeStock_497062500: TDataModule},
  USVGAdobeStock in '..\_PRIVATE\assets\AdobeStock\SVG-du-jeu\USVGAdobeStock.pas',
  Olf.FMX.TextImageFrame in '..\lib-externes\librairies\src\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame},
  uSceneTestButtonsAndDialogs in 'uSceneTestButtonsAndDialogs.pas' {SceneTestButtonsAndDialogs: TFrame},
  cButtonIcon in 'cButtonIcon.pas' {ButtonIcon: TFrame},
  uSceneHome in 'uSceneHome.pas' {SceneHome: TFrame},
  udmAdobeStock_244522135_244522157 in '..\_PRIVATE\assets\AdobeStock\AdobeStock_244522135_244522157\BubbleFontPNG\udmAdobeStock_244522135_244522157.pas' {dmAdobeStock_244522135_244522157: TDataModule},
  cDialogBox in 'cDialogBox.pas' {DialogBox: TFrame},
  uStarFieldData in 'uStarFieldData.pas',
  uSceneCredits in 'uSceneCredits.pas' {SceneCredits: TFrame},
  uSceneGameOverLost in 'uSceneGameOverLost.pas' {SceneGameOverLost: TFrame},
  USVGBubbles in '..\_PRIVATE\assets\AdobeStock\bubbles\SVG\USVGBubbles.pas',
  uSceneGame in 'uSceneGame.pas' {SceneGame: TFrame};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMGameControllerCenter, DMGameControllerCenter);
  Application.CreateForm(TdmAdobeStock_497062500, dmAdobeStock_497062500);
  Application.CreateForm(TdmAdobeStock_244522135_244522157, dmAdobeStock_244522135_244522157);
  Application.Run;
end.
