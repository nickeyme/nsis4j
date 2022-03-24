
# ====================== �Զ���� ==============================
!define PRODUCT_NAME           "NSIS Plugin Demo"
!define EXE_NAME               "360Safe.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "None"
!define PRODUCT_LEGAL          "*** 1999-2014"
!define TEMP_DIR               "e:\temp"

# ===================== ����ȫ�ֱ��� ===========================
Var paramInstllDir      # ��������-��װĿ¼


# ===================== �ⲿ����Լ��� =============================
!include "MUI2.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!insertmacro GetParameters
!insertmacro GetOptions

# ===================== ��װ���汾 =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ==================== NSIS���� ================================
; ��װ������.
Name "${PRODUCT_NAME}"

# ��װ�����ļ���.
OutFile "nsis-demo.exe"

# Ĭ�ϰ�װλ��.
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

# ������ʾ�ڰ�װ���ڵײ����ı�(Ĭ��Ϊ��Nullsoft Install System vX.XX��).
BrandingText "${PRODUCT_PUBLISHER}"

# �����Ƿ���ʾ��װ��ϸ��Ϣ��
ShowInstDetails show

# �����Ƿ���ʾж����ϸ��Ϣ
ShowUnInstDetails   show

# ���Vista��win7 ��UAC����Ȩ������.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel highest

# ��Ĭ��װ
;SilentUnInstall silent
;SilentInstall silent

# ==================== MUI���� ==================================
# ��װ��ж�س���ͼ��
!define MUI_ICON              "logo.ico"
!define MUI_UNICON            "logo.ico"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

# �Զ���ҳ��
Page custom DUIPage
page custom KeyPageCreate KeyPageLeave

# ��װ����ӭҳ��
!define MUI_WELCOMEPAGE_TITLE "��ӭʹ�á����������װ��"
!define MUI_WELCOMEPAGE_TEXT  "���򵼽���������ɡ���������İ�װ��"
!insertmacro MUI_PAGE_WELCOME

# ��װ���������Ȩ����
!insertmacro MUI_PAGE_LICENSE "readme.rtf"

# ��װ������ʾ��װ���ѡ��
!insertmacro MUI_PAGE_COMPONENTS

# ��װ������ʾ��תĿ¼ѡ��
!define MUI_PAGE_CUSTOMFUNCTION_SHOW dirPageShow  # ��ҳ����ʾ֮ǰִ��
!insertmacro MUI_PAGE_DIRECTORY

Function dirPageShow
    MessageBox MB_ICONQUESTION|MB_OK "��װĿ¼ѡ��" /SD IDOK
FunctionEnd


# ��װ������ʾ����
!insertmacro MUI_PAGE_INSTFILES

# ��װ������ʾ��װ����
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "��װ����Ժ�����Ӧ�ó���"
!insertmacro MUI_PAGE_FINISH

# ж�س�����ʾ����
!insertmacro MUI_UNPAGE_INSTFILES

# ж�س�����ʾ��װ����
!insertmacro MUI_UNPAGE_FINISH

# ָ�����ԣ����������ָ��
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= �Զ���ҳ�� ============================
Var hKeyDlg
Var dlgHeight
Var dlgWidth
Var hLbl
Var hText
Var hBtnNext
Var hImgCtrlBk
Var hImg


Function KeyPageCreate

    # ��ȡ�������С
    NSISHelper::GetDialogSize $HWNDPARENT
    Pop $dlgWidth
    Pop $dlgHeight
    
    # ���ظ������һЩ�ؼ�
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}

    # �����µ��Ӵ���
    nsDialogs::Create /NOUNLOAD 1018
    Pop $hKeyDlg
    ${If} $hKeyDlg == error
        Abort
    ${EndIf}
    
    # �����Ӵ����С��λ��
    System::Call "user32::SetWindowPos(i$hKeyDlg,i0,i0,i0,i$dlgWidth,i$dlgHeight,i0x4)"
	  
	  # ���Ӵ����д����ؼ�
	  
	  ${NSD_CreateLabel} 20 20 100 20 "�������к�:"
	  Pop $hLbl
	  SetCtlColors $hLbl ""  transparent
	  ${NSD_CreateText} 20 60 150 20 "1234567890"
	  Pop $hText 
	  
	  IntOp $R1 $dlgWidth / 2
	  IntOp $R2 $dlgHeight - 80
	  ${NSD_CreateButton} $R1 $R2 85 20 "��һ��"
	  Pop $hBtnNext
	  ${NSD_OnClick} $hBtnNext btnNextOnClick
	  
	  ${NSD_AddStyle} $hBtnNext "${BS_BITMAP}" 
    System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\btn.bmp", i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s' 
    Pop $1
    SendMessage $hBtnNext ${BM_SETIMAGE} ${IMAGE_BITMAP} $1
	  
	  ${NSD_CreateBitmap} 0 0 $dlgWidth $dlgHeight ""
	  Pop $hImgCtrlBk
	  ${NSD_SetImage} $hImgCtrlBk $PLUGINSDIR\bg.bmp $hImg
	  
	  # ��ʾ�Ӵ���
    nsDialogs::Show
    
    ${NSD_FreeImage} $hImg
FunctionEnd

Function KeyPageLeave
    # ��ԭ��������ʽ�Լ��ؼ���״̬
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_SHOW}
    GetDlgItem $1 $HWNDPARENT 2
    ShowWindow $1 ${SW_SHOW}
FunctionEnd

Function btnNextOnClick
    ${NSD_GetText} $hText $R1
    MessageBox MB_ICONQUESTION|MB_OK "��������к�Ϊ:$R1" /SD IDOK
    
    # ����һ������ť����BM_CLICK��Ϣ
    GetDlgItem $0 $HWNDPARENT 1
    SendMessage $0 0x00F5 0 0
FunctionEnd

# ======================= DUILIB �Զ���ҳ�� =========================
Var hDUIDlg

Function DUIPage
    NSISHelper::InitDUISetup
    Pop $hDUIDlg
    
    #�󶨺���-�رհ�ť
    NSISHelper::FindControl "btnClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        NSISHelper::OnControlBindNSISScript "btnClose" $0
    ${EndIf}
    
    #�󶨺���-��һ����ť
    NSISHelper::FindControl "btnNext"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnNextClick
        NSISHelper::OnControlBindNSISScript "btnNext" $0
    ${EndIf}
    
    
    NSISHelper::ShowPage
FunctionEnd

Function OnBtnNextClick
    MessageBox MB_ICONQUESTION|MB_OK "!" /SD IDOK
    GetDlgItem $0 $HWNDPARENT 1
    SendMessage $0 0x00F5 0 0   
FunctionEnd

Function OnExitDUISetup
    NSISHelper::ExitDUISetup
FunctionEnd



# ========================= ��װ���� ===============================

# ����1
# ��������һ�� ! ��ͷ����ô�����ε���ʾ���ƽ��Դ�������ʾ.
Section "!Files" "des_files"

  ; �����ļ������·��
  SetOutPath $INSTDIR
  
  ; �����ļ�
  File "app\DuiLib_ud.dll"
  File "app\${EXE_NAME}"
  
  SetOutPath "$INSTDIR\skin"
  File /r /x *.svn "app\skin\"
  
SectionEnd


# ����2
Section "Shortcut" "des_shortcut"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  SetShellVarContext current
SectionEnd


# ����3
# ������Ϊ�ա���©������һ�� "-" ��ͷ����ô������һ�����ص����Σ��û�Ҳ����ѡ���ֹ��.
Section "-Necessary"

	# ����ж�س���
	WriteUninstaller "$INSTDIR\uninst.exe"
	
	# ���ж����Ϣ���������
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
SectionEnd


# ж������
Section "Uninstall"

  ; ɾ����ݷ�ʽ
  SetShellVarContext all
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}\"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  SetShellVarContext current
  
  SetOutPath "$INSTDIR"

  ; ɾ����װ���ļ�
  Delete "$INSTDIR\*.*"

  SetOutPath "$DESKTOP"

  RMDir /r "$INSTDIR"
  RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd

# ��������
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${des_files}     "�������ļ�"
  !insertmacro MUI_DESCRIPTION_TEXT ${des_shortcut}  "������ʼ�˵��������ݷ�ʽ"
!insertmacro MUI_FUNCTION_DESCRIPTION_END


# ============================= �Զ��庯����� =====================================
# ������������
!macro ParseParameters
	${GetParameters} $R0
	${GetOptions} $R0 '/installdir' $R1
	StrCpy $paramInstllDir $R1
	IfSilent +1 end
	StrLen $R1 $paramInstllDir
	${If} $R1 > 0
		StrCpy $INSTDIR $paramInstllDir
	${EndIf}
end:
!macroend

# ��ֹ����
Function TerminateProcess
	# Please see http://nsis.sourceforge.net/KillProcDLL_plug-in
	#            http://nsis.sourceforge.net/ExecCmd_plug-in
again:
	KillProcDLL::KillProc "${EXE_NAME}"
	${If} $R0 == 0 # ��ֹ�ɹ�
		goto end
	${ElseIf} $R0 == 603 # ���̲�����
		goto end
	${ElseIf} $R0 == 604 # ��Ȩ��
		ExecCmd::exec '"taskkill" /F /IM ${EXE_NAME} /T'
		goto again
	${EndIf}
end:
FunctionEnd


# ============================== �ص����� ====================================

# �������ԡ�.����ͷ��һ����Ϊ�ص���������.
# �������ԡ�un.����ͷ�ĺ������ᱻ������ж�س������ˣ���ͨ��װ���κͺ������ܵ���ж�غ�������ж�����κ�ж�غ���Ҳ���ܵ�����ͨ������

Function .onInit
    # �Զ�����ʱĿ¼��ʹ�ò��chngvrbl.dll��
    StrCpy $0 "${TEMP_DIR}"
    StrCmp $0 "" end +1
    File /oname=$0\chngvrbl.dll "${NSISDIR}\Plugins\x86-ansi\chngvrbl.dll"
    Push $0
    Push 25 ; $TEMP
    CallInstDLL "$0\chngvrbl.dll" changeVariable
    Delete "$0\chngvrbl.dll"
end:
FunctionEnd

Function onGUIInit
 
    MessageBox MB_ICONQUESTION|MB_OK "��ʱĿ¼:$TEMP" 

    File /oname=$PLUGINSDIR\bg.bmp "bg.bmp"
    File /oname=$PLUGINSDIR\btn.bmp "btn.bmp"
    
    !insertmacro ParseParameters 
FunctionEnd


# ��װ�ɹ��Ժ�.
Function .onInstSuccess

FunctionEnd

# �ڰ�װʧ�ܺ��û������ȡ������ťʱ������.
Function .onInstFailed

FunctionEnd


# ÿ���û����İ�װ·����ʱ����δ��붼�ᱻ����һ��.
Function .onVerifyInstDir

FunctionEnd

# ж�ز�����ʼǰ.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "ȷ��Ҫж����?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# ж�سɹ��Ժ�.
Function un.onUninstSuccess
    MessageBox MB_ICONQUESTION|MB_OK "ж�سɹ�!" /SD IDOK
FunctionEnd


