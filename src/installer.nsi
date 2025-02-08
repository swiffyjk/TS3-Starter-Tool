Unicode true
Target amd64-unicode

;-------------------------------------------------------------------------------
; Includes
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\assets\InstallerImage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\assets\UninstallerImage.bmp"
!include "ModernXL.nsh"
!include "MUI2.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!include "LogicLib.nsh"

Var EAINSTDIR
Var STEAMINSTDIR
Var Platform
;-------------------------------------------------------------------------------
; Steam game directory
;-------------------------------------------------------------------------------
Function .onInit
	ReadRegStr $STEAMINSTDIR HKLM "SOFTWARE\WOW6432Node\Sims(Steam)\The Sims 3" "install dir"
	ReadRegStr $EAINSTDIR HKLM "SOFTWARE\WOW6432Node\Sims\The Sims 3" "Install Dir"
	StrCmp $STEAMINSTDIR "" 0 +4
	StrCmp $EAINSTDIR "" 0 +8
	MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Installation directory not found!" 
	Abort
	StrCmp $EAINSTDIR "" 0 +4
	ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\Sims(Steam)\The Sims 3" "install dir"
	StrCpy $Platform "Steam"
	StrCmp $INSTDIR "" 0 +5
	MessageBox MB_YESNO|MB_ICONQUESTION "It looks like you've got The Sims 3 installed on both Steam and the EA App/Disc. The Starter Tool can be installed on both. Select 'Yes' to install for Steam and 'No' to install for the EA App/Disc." IDYES +4
	ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\Sims\The Sims 3" "Install Dir"
	StrCpy $Platform "EADisc"
	StrCmp $INSTDIR "" 0 +3
	ReadRegStr $INSTDIR HKLM "SOFTWARE\WOW6432Node\Sims(Steam)\The Sims 3" "install dir"
	StrCpy $Platform "Steam"
FunctionEnd

;-------------------------------------------------------------------------------
; Constants
!define PRODUCT_NAME "The Sims 3 Starter Tool"
!define PRODUCT_DESCRIPTION "The Sims 3 Starter Tool"
!define COPYRIGHT "2025 swiffy"
!define PRODUCT_VERSION "1.0.0.0"
!define SETUP_VERSION 1.0.0.0

;-------------------------------------------------------------------------------
; Installer Setup
Name "The Sims 3 Starter Tool"
OutFile "..\bin\TS3StarterTool-Installer.exe"
RequestExecutionLevel admin
SetCompressor /SOLID LZMA
ManifestDPIAware True
VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey "FileVersion" "${SETUP_VERSION}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
ShowInstDetails show

;-------------------------------------------------------------------------------
; Modern UI Appearance (Installer)
brandingText "swiffy Installer v1.0"
!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_COLORS "FFFFFF 000000"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "..\assets\InstallerHeader.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "..\assets\UninstallerHeader.bmp"
!define MUI_HEADERIMAGE_BITMAP_STRETCH AspectFitHeight
!define MUI_HEADERIMAGE_UNBITMAP_STRETCH AspectFitHeight
!define MUI_ICON "..\assets\InstallerIcon.ico"
!define MUI_UNICON "..\assets\UninstallerIcon.ico"

!define MUI_WELCOMEPAGE_TEXT "Welcome to The Sims 3 Starter Tool Installer. $\n$\nThis installer will apply the most essential fixes to your Sims 3 game, letting the game run much better, with less bugs and frame drops! It also equips you with a simple Mods folder to add mods and custom content. $\n$\nThis installer requires an existing installed copy of The Sims 3 using the discs, Steam or the EA App. $\n$\nPlease ensure you are using the latest version of this starter tool directly from the GitHub!"
!define MUI_FINISHPAGE_NOAUTOCLOSE

;-------------------------------------------------------------------------------
; Installer Pages (Welcome, Components, etc.)
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
    !define MUI_PAGE_HEADER_TEXT_INSTALLER "TS3 Starter Tool: Installer"
    !define MUI_WELCOMEPAGE_TITLE_INSTALLER "The Sims 3 Starter Tool: Installer"  ; Unique definition for Installer
!insertmacro MUI_PAGE_FINISH

;-------------------------------------------------------------------------------
; Uninstaller Pages
    !define MUI_PAGE_HEADER_TEXT_UNINSTALLER "TS3 Starter Tool: Uninstaller"
    !define MUI_WELCOMEPAGE_TITLE_UNINSTALLER "The Sims 3 Starter Tool: Uninstaller"  ; Unique definition for Uninstaller
    !define MUI_WELCOMEPAGE_TEXT_UNINSTALLER "Welcome to The Sims 3 Starter Tool Uninstaller. $\n$\nPlease beware that if you have installed Katy Perry Sweet Treats and used any of the content in a savefile, it will be removed or replaced by the game. Please make backups of these if you need to."
    !define MUI_PAGE_HEADER_TEXT_UNINSTALLING "TS3 Starter Tool: Uninstaller"
    !define MUI_PAGE_HEADER_SUBTEXT_UNINSTALLING "Subheader blah"
    !define MUI_UNCONFIRMPAGE_TEXT_TOP "The Sims 3 Starter Tool will be uninstalled from the following folder."
    !define MUI_UNCONFIRMPAGE_TEXT_LOCATION "Folder"
    !define MUI_PAGE_HEADER_TEXT_UNINSTALLING_FINAL "Uninstalling The Sims 3 Starter Tool"
    !define MUI_PAGE_HEADER_SUBTEXT_UNINSTALLING_FINAL "Please wait while The Sims 3 Starter Tool is being uninstalled."
    !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Uninstall Complete"
    !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "Uninstall was completed successfully."
    !define MUI_FINISHPAGE_TITLE_UNINSTALL "The Sims 3 Starter Tool Uninstall Completed"
    !define MUI_FINISHPAGE_TEXT_UNINSTALL "The Sims 3 Starter Tool has been uninstalled from your computer. $\n$\nClick Finish to close Setup."
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;-------------------------------------------------------------------------------
; Languages
!insertmacro MUI_LANGUAGE "English"

;-------------------------------------------------------------------------------
; Installer Sections
Section "The Sims 3 Starter Tool Base" Section1
	SectionIn RO
	CreateDirectory '$SMPROGRAMS\The Sims 3 Starter Tool\'
	WriteUninstaller "$INSTDIR\Uninstall The Sims 3 Starter Tool.exe"
	CreateShortCut '$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool.lnk' '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' "" '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' 0
	WriteRegStr HKLM "swiffy\The Sims 3 Starter Tool" "Steam" "installed"
	WriteRegStr HKLM "swiffy\The Sims 3 Starter Tool" "EADisc" "installed"
SectionEnd

Section "Mods Folder" Section2
SectionEnd

Section "Smooth Patch" Section3
SectionEnd

Section "Updated GPU Database" Section4
SectionEnd

Section "VRAM Usage Fix" Section5
SectionEnd

Section "CPU Usage Fix" Section6
SectionEnd

Section "Intel Modern CPU Patch" Section7
SectionEnd

Section "GPU Update Fix" Section8
SectionEnd

Section /o "Disable network features" Section9
SectionEnd

Section /o "Katy Perry Sweet Treats" Section10
    AddSize 127670
    SetDetailsPrint both
    DetailPrint "Downloading Katy Perry Sweet Treats..."
    NScurl::http GET "https://raw.githubusercontent.com/swiffyjk/TS3-Starter-Tool/main/resources/KPST/KPST-Steam.7z" "$INSTDIR\temp\SP6.7z" /INSIST /END
    Pop $0
    DetailPrint "Katy Perry Sweet Treats download status: $0"
    SetOutPath "$INSTDIR"
    Nsis7z::ExtractWithDetails "$INSTDIR\temp\SP6.7z" "Extracting Katy Perry Sweet Treats.7z... %s"
    SetOutPath "$INSTDIR"
    RMDir /r "$INSTDIR\temp\"
SectionEnd

;-------------------------------------------------------------------------------
; Uninstaller Sections
Section "Uninstall"
    ReadRegStr $Platform HKCU "Software\MyApp" "Platform"
    StrCmp $Platform "EADisc" 0 +3
    CreateShortCut '$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (Steam version).lnk' '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' "" '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' 0
    StrCmp $Platform "Steam" 0 +2
    CreateShortCut '$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (EA or disc version).lnk' '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' "" '$INSTDIR\Uninstall The Sims 3 Starter Tool.exe' 0
    MessageBox MB_OK "Platform is $Platform"
    RMDir /r "$INSTDIR\SP6"
    Delete "$INSTDIR\Uninstall The Sims 3 Starter Tool.exe"
SectionEnd

;-------------------------------------------------------------------------------
; MUI Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Section1} "Section1"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section2} "Section2"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section3} "Section3"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section4} "Section4"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section5} "Section5"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section6} "Section6"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section7} "Section7"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section8} "Section8"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section9} "Section9"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section10} "This stuff pack (SP6) can no longer be legitimately purchased digitally and is therefore considered abandonware. This installer can add it into your game seamlessly."
!insertmacro MUI_FUNCTION_DESCRIPTION_END
