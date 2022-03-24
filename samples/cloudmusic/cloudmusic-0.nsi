
# ====================== �Զ���� ==============================
!define PRODUCT_NAME           "����������"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"
!define TEMP_DIR               ""


# ===================== �ⲿ����Լ��� =============================
!include "MUI2.nsh"


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
# ZLIB(Ĭ��) BZIP2 LZMA 
SetCompressor lzma

; ��װ������.
Name "${PRODUCT_NAME}"

# ��װ�����ļ���.
OutFile "���������ְ�װ0.exe"

# Ĭ�ϰ�װλ��.
InstallDir "$PROGRAMFILES\Netease\CloudMusic"


# �����Ƿ���ʾ��װ��ϸ��Ϣ��
ShowInstDetails hide

# �����Ƿ���ʾж����ϸ��Ϣ
ShowUnInstDetails   hide

# ���Vista��win7 ��UAC����Ȩ������.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin


# ==================== MUI���� ==================================
# ��װ��ж�س���ͼ��
!define MUI_ICON              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"


# ���δʹ��MUI�����ֱ��ʹ��.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit


# ��װ����ӭҳ��
!insertmacro MUI_PAGE_WELCOME

# ��װ���������Ȩ����ҳ��
!insertmacro MUI_PAGE_LICENSE "license.rtf"


# ��װ������ʾ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY

# ��װ������ʾ��װ���ѡ��ҳ��
!insertmacro MUI_PAGE_COMPONENTS

# ��װ������ʾ����ҳ��
!insertmacro MUI_PAGE_INSTFILES

# ��װ������ʾ��װ����ҳ��
!insertmacro MUI_PAGE_FINISH


# ж�س�����ʾ����
!insertmacro MUI_UNPAGE_INSTFILES

# ж�س�����ʾ��װ����
!insertmacro MUI_UNPAGE_FINISH

# ָ�����ԣ����������ָ��
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= ��װ���� ===============================

# ����1
# ��������һ�� ! ��ͷ����ô�����ε���ʾ���ƽ��Դ�������ʾ.
Section "!Files" "des_files"

  ; �����ļ������·��
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


# ��������
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${des_files}     "�������ļ�"
  !insertmacro MUI_DESCRIPTION_TEXT ${des_shortcut}  "������ʼ�˵��������ݷ�ʽ"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# ============================== �ص����� ====================================

# �������ԡ�.����ͷ��һ����Ϊ�ص���������.
# �������ԡ�un.����ͷ�ĺ������ᱻ������ж�س������ˣ���ͨ��װ���κͺ������ܵ���ж�غ�������ж�����κ�ж�غ���Ҳ���ܵ�����ͨ������

Function .onInit
FunctionEnd

Function onGUIInit

FunctionEnd


# ��װ�ɹ��Ժ�.
Function .onInstSuccess

FunctionEnd


# ж�ز�����ʼǰ.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "��ȷʵҪ��ȫɾ�����������֣��������������?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# ж�سɹ��Ժ�.
Function un.onUninstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} �ѳɹ��ش���ļ�����Ƴ�" /SD IDOK
FunctionEnd


