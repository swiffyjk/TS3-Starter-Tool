Unicode true
Target amd64-unicode

!define MUI_TITLE "The Sims 3 Starter Tool: Installer (v$Version)"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\assets\InstallerImage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\assets\UninstallerImage.bmp"
!define MUI_ICON "..\assets\InstallerIcon.ico"
!define MUI_UNICON "..\assets\UninstallerIcon.ico"

;-------------------------------------------------------------------------------
; Includes
!include "ModernXL.nsh"
!include "MUI2.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!include "LogicLib.nsh"
;FileExists is already part of LogicLib, but returns true for directories as well as files
!macro _FileExists2 _a _b _t _f
	!insertmacro _LOGICLIB_TEMP
	StrCpy $_LOGICLIB_TEMP "0"
	StrCmp `${_b}` `` +4 0 ;if path is not blank, continue to next check
	IfFileExists `${_b}` `0` +3 ;if path exists, continue to next check (IfFileExists returns true if this is a directory)
	IfFileExists `${_b}\*.*` +2 0 ;if path is not a directory, continue to confirm exists
	StrCpy $_LOGICLIB_TEMP "1" ;file exists
	;now we have a definitive value - the file exists or it does not
	StrCmp $_LOGICLIB_TEMP "1" `${_t}` `${_f}`
!macroend
!undef FileExists
!define FileExists `"" FileExists2`
!macro _DirExists _a _b _t _f
	!insertmacro _LOGICLIB_TEMP
	StrCpy $_LOGICLIB_TEMP "0"	
	StrCmp `${_b}` `` +3 0 ;if path is not blank, continue to next check
	IfFileExists `${_b}\*.*` 0 +2 ;if directory exists, continue to confirm exists
	StrCpy $_LOGICLIB_TEMP "1"
	StrCmp $_LOGICLIB_TEMP "1" `${_t}` `${_f}`
!macroend
!define DirExists `"" DirExists`

Var EAINSTDIR
Var STEAMINSTDIR
Var Platform
Var SteamRegDetected
Var EARegDetected
Var Version
Var TotalSize
Var UninstallerPath
Var SOFTWAREORWOW6432NODE
Var RegCountry
Var RegLocale

Function .onInit
	;-------------------------------------------------------------------------------
	; Variables
	StrCpy $Version 0.1
	${If} ${RunningX64}
		StrCpy $SOFTWAREORWOW6432NODE "SOFTWARE\WOW6432Node"
	${Else}
		StrCpy $SOFTWAREORWOW6432NODE "SOFTWARE"
	${EndIf}
	;-------------------------------------------------------------------------------
	; Game directory + platform selection
	ReadRegStr $STEAMINSTDIR HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3" "install dir"
	ReadRegStr $EAINSTDIR HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3" "Install Dir"

	${If} "$STEAMINSTDIR" != "" ; If Steam directory is not blank (If Steam installation is detected in registry)
		${If} "$EAINSTDIR" != "" ; If Steam AND EA directory are not blank (If EA and Steam installations are detected in registry)
			MessageBox MB_YESNO|MB_ICONQUESTION "It looks like you've got The Sims 3 installed on both Steam and the EA App/Disc. The Starter Tool can be installed on both. Select 'Yes' to install for Steam and 'No' to install for the EA App/Disc." IDYES SteamInit IDNO EAInit
		${Else} ; If Steam directory is not blank and EA directory is blank (If only Steam installation is detected in registry)
			Goto SteamInit
		${EndIf}
	${ElseIf} "$EAINSTDIR" != "" ; If EA directory is not blank (If only EA installation is detected in registry)
		Goto EAInit
	${Else} ; Neither EA nor Steam directory found in registry
		MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Couldn't find The Sims 3! Make sure you've got it installed on Steam, the EA App, or fully Super-Patched if using the discs. See the 'What's this?' section of the Starter Guide for more info." 
		Abort
	${EndIf}

	EAInit:
	StrCpy $Platform "EA"
	ReadRegStr $INSTDIR HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3" "Install Dir"
	Goto OnInitFunctionEnd

	SteamInit:
	StrCpy $Platform "Steam"
	ReadRegStr $INSTDIR HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3" "install dir"
	Goto OnInitFunctionEnd

	OnInitFunctionEnd:
FunctionEnd
	
;-------------------------------------------------------------------------------
; Constants
Caption "The Sims 3 Starter Tool: Installer"
!define PRODUCT_NAME $Version 
!define PRODUCT_DESCRIPTION "The Sims 3 Starter Tool"
!define COPYRIGHT "swiffy / EA"
!define VERSION 0.1
!define PRODUCT_VERSION 0.1.0.0
!define SETUP_VERSION 0.1.0.0

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
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "FileVersion" "${SETUP_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
ShowInstDetails show

;-------------------------------------------------------------------------------
; Modern UI Appearance
brandingText "swiffy Installer v0.1"
!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_COLORS "FFFFFF 000000"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "..\assets\InstallerHeader.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "..\assets\UninstallerHeader.bmp"
!define MUI_HEADERIMAGE_BITMAP_STRETCH AspectFitHeight
!define MUI_HEADERIMAGE_UNBITMAP_STRETCH AspectFitHeight

!define MUI_WELCOMEPAGE_TEXT "Welcome to The Sims 3 Starter Tool Installer. $\n$\nThis installer will apply the most essential fixes to your Sims 3 game, letting the game run much better, with less bugs and frame drops! It also equips you with a simple Mods folder to add mods and custom content. $\n$\nThis installer requires an existing installed copy of The Sims 3 using the discs, Steam or the EA App. $\n$\nPlease ensure you are using the latest version of this starter tool directly from the GitHub!"
!define MUI_PAGE_HEADER_TEXT_INSTALLER "TS3 Starter Tool: Installer"
!define MUI_WELCOMEPAGE_TITLE "The Sims 3 Starter Tool: Installer (v$Version)" 
!define MUI_FINISHPAGE_NOAUTOCLOSE

;-------------------------------------------------------------------------------
; Installer Pages (Welcome, Components, etc.)
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;-------------------------------------------------------------------------------
; Uninstaller Pages
    !define MUI_PAGE_HEADER_TEXT_UNINSTALLER "TS3 Starter Tool: Uninstaller"
    !define MUI_WELCOMEPAGE_TITLE_UNINSTALLER "The Sims 3 Starter Tool: Uninstaller"
    !define MUI_WELCOMEPAGE_TEXT_UNINSTALLER "Welcome to The Sims 3 Starter Tool Uninstaller. $\n$\nPlease beware that if you have installed Katy Perry Sweet Treats and used any of the content in a savefile, it will be removed or replaced by the game. Please make backups of these if you need to."
    !define MUI_PAGE_HEADER_TEXT_UNINSTALLING "TS3 Starter Tool: Uninstaller"
    !define MUI_PAGE_HEADER_SUBTEXT_UNINSTALLING "Please wait while The Sims 3 Starter Tool is being uninstalled."
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
	AddSize 1
	IntOp $TotalSize $TotalSize + 1

	DetailPrint "Platform detected as $Platform"
	CreateDirectory '$INSTDIR\Starter Tool\'
	WriteUninstaller "$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe"
	CreateDirectory '$SMPROGRAMS\The Sims 3 Starter Tool\'
	SetOutPath "$INSTDIR\Starter Tool\"
	File "..\assets\InstallerIcon.ico"
	SetFileAttributes "$INSTDIR\Starter Tool\InstallerIcon.ico" hidden
	
	${If} "$Platform" == "Steam"
		DetailPrint "Writing registry info..."
		WriteRegStr HKLM "SOFTWARE\The Sims 3 Starter Tool Steam" "Initial install directory" "$INSTDIR"
		WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "DisplayName" "The Sims 3 Starter Tool (Steam)"
		CreateShortCut '$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (Steam).lnk' '$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe' "" '$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe' 0
	${ElseIf} "$Platform" == "EA"
		DetailPrint "Writing registry info..."
		WriteRegStr HKLM "SOFTWARE\The Sims 3 Starter Tool EA" "Initial install directory" "$INSTDIR"	
		WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "DisplayName" "The Sims 3 Starter Tool (EA~Disc)"
		CreateShortCut '$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (EA~Disc).lnk' '$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe' "" '$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe' 0
	${EndIf}

	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "NoModify" 1
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "NoRepair" 1
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "URLInfoAbout" "https://github.com/swiffyjk/TS3-Starter-Tool"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "DisplayIcon" "$INSTDIR\Starter Tool\InstallerIcon.ico"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "InstallLocation" "$INSTDIR"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "Publisher" "swiffy / EA"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "DisplayVersion" "$VERSION"
	WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform" "UninstallString" "$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe"
	
SectionEnd

Section /o "Mods Folder" Section2 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "Smooth Patch" Section3 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "Updated GPU Database" Section4 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "VRAM Usage Fix" Section5 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "CPU Usage Fix" Section6 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "Intel Modern CPU Patch" Section7 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "GPU Update Fix" Section8 ; /o and RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "Disable network features" Section9 ; RO temporary to grey out
	SectionIn RO
	AddSize 1
	IntOp $TotalSize $TotalSize + 1
SectionEnd

Section /o "Katy Perry Sweet Treats" Section10
	AddSize 127670
	IntOp $TotalSize $TotalSize + 127670
	SetDetailsPrint both
	SetOutPath "$INSTDIR"	

	${If} "$Platform" == "Steam"
		DetailPrint "Downloading Katy Perry Sweet Treats..."

		NScurl::http GET "https://raw.githubusercontent.com/swiffyjk/TS3-Starter-Tool/main/resources/KPST/KPST-Steam.7z" "$INSTDIR\temp\SP6.7z" /INSIST /END
		Pop $0
		DetailPrint "Katy Perry Sweet Treats (Steam version) download status: $0"
		Nsis7z::ExtractWithDetails "$INSTDIR\temp\SP6.7z" "Extracting Katy Perry Sweet Treats.7z... %s"

		ReadRegStr $RegCountry HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3" "country"
		ReadRegStr $RegLocale HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3" "locale"

		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Electronic Arts\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats\ergc" "" "KPST-TS3S-TART-ERPA-CKXY"

		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "contentid" "sims3_sp06_sku7"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "country" "$RegCountry"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "displayname" "The Sims 3 Katy Perry's Sweet Treats"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "ergcregpath" "Electronic Arts\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats\ergc"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "exepath" "$INSTDIR\SP6\Game\Bin\TS3SP06.exe"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "install dir" "$INSTDIR\SP6"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "locale" "$RegLocale"

		WriteRegDWORD HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "productid" 13
		WriteRegDWORD HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "sku" 7
		WriteRegDWORD HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats" "telemetry" 0

	${ElseIf} "$Platform" == "EA"
		DetailPrint "Downloading Katy Perry Sweet Treats..."
		NScurl::http GET "https://raw.githubusercontent.com/swiffyjk/TS3-Starter-Tool/main/resources/KPST/KPST-EA.7z" "$INSTDIR\temp\SP06.7z" /INSIST /END
		Pop $0
		DetailPrint "Katy Perry Sweet Treats (EA/Disc version) download status: $0"
		SetOutPath "$INSTDIR"	
		Nsis7z::ExtractWithDetails "$INSTDIR\temp\SP06.7z" "Extracting Katy Perry Sweet Treats.7z... %s"

		CreateDirectory "$PROGRAMFILES32\Common Files\EAInstaller\The Sims 3\The Sims 3 Katy Perry Sweet Treats"
		nsExec::ExecToLog 'attrib +h "$PROGRAMFILES32\Common Files\EAInstaller"'
		nsExec::ExecToLog 'attrib +h "$PROGRAMFILES32\Common Files\EAInstaller\The Sims 3"'
		nsExec::ExecToLog 'attrib +h "$PROGRAMFILES32\Common Files\EAInstaller\The Sims 3\The Sims 3 Katy Perry Sweet Treats"'

		DetailPrint "Downloading Katy Perry Sweet Treats cleanup files..."
		NScurl::http GET "https://raw.githubusercontent.com/swiffyjk/TS3-Starter-Tool/main/resources/KPST/KPST-EA-Cleanup.7z" "$INSTDIR\temp\Cleanup.7z" /INSIST /END
		Pop $0
		DetailPrint "Katy Perry Sweet Treats (EA/Disc cleanup files) download status: $0"
		SetOutPath "$PROGRAMFILES32\Common Files\EAInstaller\The Sims 3\The Sims 3 Katy Perry Sweet Treats"	
		Nsis7z::ExtractWithDetails "$INSTDIR\temp\Cleanup.7z" "Extracting Katy Perry Sweet Treats Cleanup.7z... %s"

		ReadRegStr $RegLocale HKLM "$SOFTWAREORWOW6432NODE\Origin Games\sims3_dd" "Locale"

		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3 Katy Perry Sweet Treats" "Install Dir" "$INSTDIR\SP06"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Origin Games\71444" "DisplayName" "The Sims 3 Katy Perry's Sweet Treats" ; Should be "The Sims™ 3 Katy Perry's Sweet Treats" but NSIS doesn't like that
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Origin Games\71444" "Locale" "$RegLocale"

		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3\DLCs\The Sims 3 Katy Perry Sweet Treats" "UninstallerArgs" "uninstall_pdlc -autologging"
		WriteRegStr HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3\DLCs\The Sims 3 Katy Perry Sweet Treats" "UninstallerPath" "$\"$PROGRAMFILES32\Common Files\EAInstaller\The Sims 3\The Sims 3 Katy Perry Sweet Treats\Cleanup.exe$\""


	${EndIf}
	
	RMDir /r "$INSTDIR\temp\"
SectionEnd

;-------------------------------------------------------------------------------
; Uninstaller Sections
Function un.onInit
	StrCpy $UninstallerPath "$INSTDIR\Uninstall The Sims 3 Starter Tool.exe"
	ReadRegStr $SteamRegDetected HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool Steam" "UninstallString"
	ReadRegStr $EARegDetected HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool EA" "UninstallString"

	StrCmp $UninstallerPath $SteamRegDetected SteamUnInit
	StrCmp $UninstallerPath $EARegDetected EAUnInit

	SteamUnInit:
	StrCpy $Platform "Steam"
	Goto UnOnInitFunctionEnd

	EAUnInit:
	StrCpy $Platform "EA"
	Goto UnOnInitFunctionEnd

	UnOnInitFunctionEnd:
FunctionEnd

Section "Uninstall"
	DeleteRegKey HKLM "Software\The Sims 3 Starter Tool $Platform"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\The Sims 3 Starter Tool $Platform"

	${If} "$Platform" == "Steam"
		Delete "$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (Steam).lnk"
		RMDir /r "$INSTDIR\SP6\"
		
		DeleteRegKey HKLM "$SOFTWAREORWOW6432NODE\Electronic Arts\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats\ergc"
		DeleteRegKey HKLM "$SOFTWAREORWOW6432NODE\Sims(Steam)\The Sims 3 Katy Perry Sweet Treats"

		StrCpy $0 "$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (EA~Disc).lnk"
	${ElseIf} "$Platform" == "EA"
		Delete "$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (EA~Disc).lnk"
		RMDir /r "$INSTDIR\SP06\"

		DeleteRegKey HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3 Katy Perry Sweet Treats"
		DeleteRegKey HKLM "$SOFTWAREORWOW6432NODE\Sims\The Sims 3\DLCs\The Sims 3 Katy Perry Sweet Treats"
		DeleteRegKey HKLM "$SOFTWAREORWOW6432NODE\Origin Games\71444"

		StrCpy $0 "$SMPROGRAMS\The Sims 3 Starter Tool\Uninstall The Sims 3 Starter Tool (Steam).lnk"
	${EndIf}

	${If} ${FileExists} $0
		; Do nothing - we don't want to delete the other uninstall shortcut by deleting the folder
	${Else}
		RMDir /r "$SMPROGRAMS\The Sims 3 Starter Tool\"
    ${EndIf}

	RMDir /r "$INSTDIR\Starter Tool\"
	Delete "$INSTDIR\Starter Tool\Uninstall The Sims 3 Starter Tool.exe"
SectionEnd

;-------------------------------------------------------------------------------
; MUI Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Section1} "The key files of the Starter Tool. No fixes are implemented here, but it's necessary for the installer to work properly and be uninstallable."
    !insertmacro MUI_DESCRIPTION_TEXT ${Section2} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section3} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section4} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section5} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section6} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section7} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section8} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section9} "This feature hasn't been implemented yet. Stay tuned for an update!"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section10} "This stuff pack (SP6) can no longer be legitimately purchased digitally and is therefore considered abandonware. This installer can add it into your game seamlessly."
!insertmacro MUI_FUNCTION_DESCRIPTION_END