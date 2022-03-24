# �ڶ����������ְ�װ������������
# ====================== �Զ���� ==============================
!define PRODUCT_NAME           "����������"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"

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
OutFile "���������ְ�װ��չ.exe"

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
!define mui_icon              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "image\modern-header.bmp"
!define MUI_PAGE_HEADER_TEXT "���֤Э��"
!define MUI_PAGE_HEADER_SUBTEXT "�ڰ�װ�����������֡�֮ǰ�����Ķ���ȨЭ�顣"

# ���δʹ��MUI�����ֱ��ʹ��.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

# �Զ���ҳ��
page custom PageKeyCreate PageKeyLeave

# ========================= �Զ���ҳ�� ============================
Var hKeyDlg
Var dlgHeight
Var dlgWidth
Var hLbl
Var hText
Var hBtnNext
Var hImgCtrlBk
Var hImg
 
Function PageKeyCreate
 
    # ��ȡ�������С
    System::Call "*(i0,i0,i0,i0) i.r1"
    System::Call "user32::GetWindowRect(i$HWNDPARENT, i$1)"
    System::Call "*$1(i.r4,i.r5,i.r6,i.r7)"
    
    IntOp $dlgWidth $6 - $4
    IntOp $dlgHeight $7 - $5

     
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
    ${NSD_SetImage} $hImgCtrlBk $PLUGINSDIR\key_bg.bmp $hImg
       
      # ��ʾ�Ӵ���
    nsDialogs::Show
     
    ${NSD_FreeImage} $hImg
FunctionEnd
 
Function PageKeyLeave
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




# ��װ����ӭҳ��
!define MUI_WELCOMEPAGE_TITLE "��ӭʹ�á����������֡���װ��"
!define MUI_WELCOMEPAGE_TEXT  "����򵼽�ָ������ɡ����������֡��İ�װ���̡�$\n$\n�ڿ�ʼ��װ֮ǰ�������ȹر���������Ӧ�ó����⽫������װ���򡱸���ָ����ϵͳ�ļ���������Ҫ����������ļ������$\n$\n����[��һ��(N)]������"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\modern-wizard.bmp"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW welcomePageShow
!insertmacro MUI_PAGE_WELCOME



Function welcomePageShow
    # ��������
    CreateFont $0 "΢���ź�" 12 700
    # ���������ʹ�ã�
    # FindWindow $0 "#32770" "" $HWNDPARENT
    # GetDlgItem $1 $0 0x4B1
    # ���ڡ���һ�����ٴ���ʾ��ҳ��ʱ��ȡ�����������Ϊ֮ǰ��#32770�ӶԻ���û���٣���ʱ��������������#32770�ӶԻ���
    # ��������2�����������
    # 1. ʹ��mui.WelcomePage.Title�������ñ���������C:\Program Files (x86)\NSIS\Contrib\Modern UI 2\Pages\Welcome.nsh
     SetCtlColors $mui.WelcomePage.Title 0xB00B0A "${MUI_BGCOLOR}"
     SendMessage $mui.WelcomePage.Title ${WM_SETFONT} $0 0
    
    # 2. ʹ��FindWindow����2��
    # FindWindow $1 "#32770" "" $HWNDPARENT
    # FindWindow $1 "#32770" "" $HWNDPARENT $1
    # ${If} $1 == 0
    #     FindWindow $1 "#32770" "" $HWNDPARENT
    # ${EndIf}
    # GetDlgItem $2 $1 0x4B1
    # SetCtlColors $2 0xB00B0A transparent
    # SendMessage $2 ${WM_SETFONT} $0 0

    # �ı�ؼ���С
    FindWindow $0 "#32770" "" $HWNDPARENT
    FindWindow $0 "#32770" "" $HWNDPARENT $0
    ${If} $0 == 0
        FindWindow $0 "#32770" "" $HWNDPARENT
    ${EndIf}
    GetDlgItem $1 $0 0x4B2
    !insertmacro GetWindowPos $0 $1 $2 $3 $4 $5
    IntOp $2 $4 - $2
    IntOp $3 $5 - $3
    IntOp $3 $3 - 100
    System::Call "User32::SetWindowPos(i$1, i0, i0, i0, i$2, i$3, i2) i.r12"
    
    
    # ���ø��ؼ�����͸��
    !insertmacro SetTransparent $0 0x4B1 0xB00B0A
    !insertmacro SetTransparent $0 0x4B2 0
FunctionEnd

# ��װ���������Ȩ����
!define MUI_LICENSEPAGE_TEXT_TOP ""
!define MUI_LICENSEPAGE_TEXT_BOTTOM "��������Э���е�������� [�ҽ���(I)] ������װ�������ѡ�� [ȡ��(C)] ����װ���򽫻�رա��������Э����ܰ�װ�����������֡���"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW licensePageShow
!insertmacro MUI_PAGE_LICENSE "license.rtf"

Function licensePageShow
    SetCtlColors $HWNDPARENT 0xFFFFFF 0xF0F0F0
FunctionEnd


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
    !insertmacro TerminateProcess "${EXE_NAME}"
FunctionEnd

Function onGUIInit
    File /oname=$PLUGINSDIR\key_bg.bmp "image\key_bg.bmp"
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


