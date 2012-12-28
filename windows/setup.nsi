!include "EnvVarUpdate.nsh"

; The name of the installer
Name "Peasant"

; The file to write
OutFile "..\bin\peasant-setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Peasant

SetCompressor lzma

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

	; Set output path to the installation directory.
	SetOutPath $INSTDIR

	; bin
	SetOutPath $INSTDIR
	File ..\bin\peasant-rb.exe
	File ..\windows\peasant.bat

	${EnvVarUpdate} $0 "PATH" "P" "HKLM" $INSTDIR

	WriteUninstaller $INSTDIR\uninstaller.exe
  
SectionEnd ; end the section

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" $INSTDIR

	RMDir /r $INSTDIR
SectionEnd
