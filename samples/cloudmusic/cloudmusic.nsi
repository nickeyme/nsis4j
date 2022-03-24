
# ====================== �Զ���� ==============================
!define PRODUCT_NAME           "����������"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"
!define TEMP_DIR               ""

# ===================== ����ȫ�ֱ��� ===========================



# ===================== �ⲿ����Լ��� =============================
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "..\..\include\common.nsh"

# ===================== ��װ���汾 =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ==================== NSIS���� ================================
SetCompressor lzma

; ��װ������.
Name "${PRODUCT_NAME}"

# ��װ�����ļ���.
OutFile "���������ְ�װ.exe"

# Ĭ�ϰ�װλ��.
InstallDir "$PROGRAMFILES\Netease\CloudMusic"

# ������ʾ�ڰ�װ���ڵײ����ı�(Ĭ��Ϊ��Nullsoft Install System vX.XX��).
BrandingText "���������� http://music.163.com"

# �����Ƿ���ʾ��װ��ϸ��Ϣ��
ShowInstDetails hide

# �����Ƿ���ʾж����ϸ��Ϣ
ShowUnInstDetails   hide

# ���Vista��win7 ��UAC����Ȩ������.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

# ��Ĭ��װ
;SilentUnInstall silent
;SilentInstall silent

# ==================== MUI���� ==================================
# ��װ��ж�س���ͼ��
!define MUI_ICON              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "image\modern-header.bmp"
!define MUI_PAGE_HEADER_TEXT "���֤Э��"
!define MUI_PAGE_HEADER_SUBTEXT "�ڰ�װ�����������֡�֮ǰ�����Ķ���ȨЭ�顣"

# ���δʹ��MUI�����ֱ��ʹ��.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit


# ��װ����ӭҳ��
!define MUI_WELCOMEPAGE_TITLE "��ӭʹ�á����������֡���װ��"
!define MUI_WELCOMEPAGE_TEXT  "����򵼽�ָ������ɡ����������֡��İ�װ���̡�$\n$\n�ڿ�ʼ��װ֮ǰ�������ȹر���������Ӧ�ó����⽫������װ���򡱸���ָ����ϵͳ�ļ���������Ҫ����������ļ������$\n$\n����[��һ��(N)]������"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\modern-wizard.bmp"
!insertmacro MUI_PAGE_WELCOME

# ��װ���������Ȩ����
!define MUI_LICENSEPAGE_TEXT_TOP ""
!define MUI_LICENSEPAGE_TEXT_BOTTOM "��������Э���е�������� [�ҽ���(I)] ������װ�������ѡ�� [ȡ��(C)] ����װ���򽫻�رա��������Э����ܰ�װ�����������֡���"
!insertmacro MUI_PAGE_LICENSE "license.rtf"



# ��װ������ʾ��תĿ¼ѡ��
!define MUI_PAGE_CUSTOMFUNCTION_SHOW dirPageShow  # ��ҳ����ʾ֮ǰִ��
!define MUI_DIRECTORYPAGE_TEXT_TOP "Ĭ�Ͻ���װ�������ļ��С�Ҫ��װ����ͬ�ļ��У�����[���(B)]��ѡ���������ļ��С�����[��װ(I)]��ʼ��װ���̡�"
!insertmacro MUI_PAGE_DIRECTORY

Function dirPageShow
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
FunctionEnd


# ��װ������ʾ����
!insertmacro MUI_PAGE_INSTFILES

# ��װ������ʾ��װ����

!define MUI_PAGE_CUSTOMFUNCTION_SHOW finishPageShow
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE finishPageLeave
!define MUI_FINISHPAGE_TITLE "������ɡ����������֡���װ��"
!define MUI_FINISHPAGE_TEXT ""
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "������������������"
!insertmacro MUI_PAGE_FINISH

Var chbCreateShortcut
Var chbAutoStart


Function finishPageShow
    ${NSD_CreateCheckbox} 120u 110u 239u 15u "������������������"
	  Pop $chbAutoStart
	  ${NSD_SetState} $chbAutoStart ${BST_CHECKED}
	  SetCtlColors $chbAutoStart "000000" ${MUI_BGCOLOR}
	  
	  ${NSD_CreateCheckbox} 120u 130u 239u 15u "���������ݷ�ʽ"
	  Pop $chbCreateShortcut
	  ${NSD_SetState} $chbCreateShortcut ${BST_CHECKED}
	  SetCtlColors $chbCreateShortcut "000000" "FFFFFF"
	  
FunctionEnd

Function finishPageLeave
    ${NSD_GetState} $chbCreateShortcut $1
    ${If} $1 == ${BST_CHECKED}
        SetShellVarContext all
        CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
        SetShellVarContext current
    ${EndIf}
    
    ${NSD_GetState} $chbAutoStart $1
    ${If} $1 == ${BST_CHECKED}
        CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
    ${EndIf}
FunctionEnd

# ж�س�����ʾ����
!insertmacro MUI_UNPAGE_INSTFILES

# ж�س�����ʾ��װ����
;!insertmacro MUI_UNPAGE_FINISH

# ָ�����ԣ����������ָ��
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= ��װ���� ===============================

# ����1
# ��������һ�� ! ��ͷ����ô�����ε���ʾ���ƽ��Դ�������ʾ.
Section "!Files" "des_files"

    SetOutPath $INSTDIR
  
    ; �����ļ�
    File /r "app\*.*"
  
SectionEnd


# ����2
Section "Shortcut" "des_shortcut"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
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



# ============================== �ص����� ====================================

# �������ԡ�.����ͷ��һ����Ϊ�ص���������.
# �������ԡ�un.����ͷ�ĺ������ᱻ������ж�س������ˣ���ͨ��װ���κͺ������ܵ���ж�غ�������ж�����κ�ж�غ���Ҳ���ܵ�����ͨ������

Function .onInit
    !insertmacro ChangeTempDir "${TEMP_DIR}"
FunctionEnd

Function onGUIInit
    !insertmacro TerminateProcess "${EXE_NAME}"
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
    MessageBox MB_ICONQUESTION|MB_YESNO "��ȷʵҪ��ȫɾ�����������֣��������������?" /SD IDYES IDYES +2 IDNO +1
    Abort
    !insertmacro TerminateProcess "${EXE_NAME}"
FunctionEnd

# ж�سɹ��Ժ�.
Function un.onUninstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} �ѳɹ��ش���ļ�����Ƴ�" /SD IDOK
FunctionEnd


