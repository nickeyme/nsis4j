
# ====================== �Զ���� ==============================
!define PRODUCT_NAME           "��ѶQQ"
!define EXE_NAME               "QQ.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "Tencent"
!define PRODUCT_LEGAL          "Copyright (C) 1999-2014 Tencent, All Rights Reserved"


# ===================== �ⲿ����Լ��� =============================
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
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

#SetCompressor zlib

; ��װ������.
Name "${PRODUCT_NAME}"

# ��װ�����ļ���.
OutFile "QQ Setup.exe"

# Ĭ�ϰ�װλ��.
InstallDir "$PROGRAMFILES\Tencent\${PRODUCT_NAME}"


# ���Vista��win7 ��UAC����Ȩ������.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

# ��װ��ж�س���ͼ��
Icon              "image\logo.ico"
UninstallIcon     "image\logo.ico"



# �Զ���ҳ��
Page custom DUIPage


# ж�س�����ʾ����
UninstPage instfiles

# ======================= DUILIB �Զ���ҳ�� =========================
Var hInstallDlg

Function DUIPage
    !insertmacro Trace "$TEMP $PLUGINSDIR"
    nsDui::InitDUISetup
    Pop $hInstallDlg
    
    # Licenseҳ��
    nsDui::FindControl "btnLicenseClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnLicenseClose" $0
    ${EndIf}
    
    nsDui::FindControl "btnLicenseMin"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnMin
        nsDui::OnControlBindNSISScript "btnLicenseMin" $0
    ${EndIf}
    
    nsDui::FindControl "btnLicenseNext"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnLicenseNextClick
        nsDui::OnControlBindNSISScript "btnLicenseNext" $0
    ${EndIf}
    
    # Ŀ¼ѡ�� ҳ��
    nsDui::FindControl "btnDirClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnDirClose" $0
    ${EndIf}
    
    nsDui::FindControl "btnDirMin"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnMin
        nsDui::OnControlBindNSISScript "btnDirMin" $0
    ${EndIf}
    
    nsDui::FindControl "btnSelectDir"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnSelectDir
        nsDui::OnControlBindNSISScript "btnSelectDir" $0
    ${EndIf}
    
    nsDui::FindControl "btnDirPre"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnDirPre
        nsDui::OnControlBindNSISScript "btnDirPre" $0
    ${EndIf}
    
    nsDui::FindControl "btnDirCancel"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnCancel
        nsDui::OnControlBindNSISScript "btnDirCancel" $0
    ${EndIf}
        
    nsDui::FindControl "btnDirInstall"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnInstall
        nsDui::OnControlBindNSISScript "btnDirInstall" $0
    ${EndIf}
    

    
    # ��װ���� ҳ��
    nsDui::FindControl "btnDetailClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnDetailClose" $0
    ${EndIf}
    
    nsDui::FindControl "btnDetailMin"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnMin
        nsDui::OnControlBindNSISScript "btnDetailMin" $0
    ${EndIf}

    # ��װ��� ҳ��
    nsDui::FindControl "btnFinished"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnFinished
        nsDui::OnControlBindNSISScript "btnFinished" $0
    ${EndIf}
    
    nsDui::FindControl "btnFinishedMin"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnBtnMin
        nsDui::OnControlBindNSISScript "btnFinishedMin" $0
    ${EndIf}
    
    nsDui::FindControl "btnFinishedClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        nsDui::OnControlBindNSISScript "btnFinishedClose" $0
    ${EndIf}
    
    nsDui::ShowPage
FunctionEnd

Function OnBtnLicenseNextClick
    nsDui::GetCheckboxStatus "chkAgree"
    Pop $0
    ${If} $0 == "1"
        nsDui::SetDirValue "$INSTDIR"
        nsDui::NextPage "wizardTab"
    ${EndIf}
FunctionEnd

# ��ʼ��װ
Function OnBtnInstall
    nsDui::GetDirValue
    Pop $0
    StrCmp $0 "" InstallAbort 0
    StrCpy $INSTDIR "$0"
    nsDui::NextPage "wizardTab"
    nsDui::SetSliderRange "slrProgress" 0 100
    
    # ���ǰ�װʱ��ָ�������ǵ��ļ�
    # ����Щ�ļ��ݴ浽��ʱĿ¼
    CreateDirectory "$TEMP\qq_file_translate"
    CopyFiles /SILENT "$INSTDIR\gf-config.xml" "$TEMP\qq_file_translate"
    
    #����һ�������ȼ��ĺ�̨�߳�
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
    
    # �ļ��ͷ�����Ժ󣬻�ԭ�ݴ���ļ�
    CopyFiles /SILENT "$TEMP\qq_file_translate\gf-config.xml" "$INSTDIR"
    RMDir /r "$TEMP\qq_file_translate"
    
    Call CreateShortcut
    Call CreateUninstall
InstallAbort:
FunctionEnd

Function ExtractFunc
    SetOutPath $INSTDIR
    File "app\app.7z"
    GetFunctionAddress $R9 ExtractCallback
    Nsis7z::ExtractWithCallback "$INSTDIR\app.7z" $R9
    Delete "$INSTDIR\app.7z"
FunctionEnd


Function ExtractCallback
    Pop $1
    Pop $2
    System::Int64Op $1 * 100
    Pop $3
    System::Int64Op $3 / $2
    Pop $0
    
    nsDui::SetSliderValue "slrProgress" $0

    ${If} $1 == $2
        nsDui::SetSliderValue "slrProgress" 100
        nsDui::NextPage "wizardTab"
    ${EndIf}
FunctionEnd


Function OnExitDUISetup
    nsDui::ExitDUISetup
FunctionEnd

Function OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

Function OnBtnCancel
FunctionEnd

Function OnFinished
    # ��������
    nsDui::GetCheckboxStatus "chkBootStart"
    Pop $R0
    ${If} $R0 == "1"
        SetShellVarContext all
        CreateShortCut "$SMSTARTUP\QQ.lnk" "$INSTDIR\Bin\QQ.exe"
    ${EndIf}
    
    # ��������
    nsDui::GetCheckboxStatus "chkStartNow"
    Pop $R0
    ${If} $R0 == "1"
        Exec "$INSTDIR\Bin\QQ.exe"
    ${EndIf}
    
    # ������ҳ
    nsDui::GetCheckboxStatus "chkSetHomePage"
    Pop $R0
    ${If} $R0 == "1"
        WriteRegStr HKCU "Software\Microsoft\Internet Explorer\Main" "Start Page" "http://www.qq.com"
    ${EndIf}
    
    # ��ʾ������
    nsDui::GetCheckboxStatus "chkShowFeature"
    Pop $R0
    ${If} $R0 == "1"
        ExecShell "open" "$INSTDIR\QQWhatsnew.txt"
    ${EndIf}
    
    Call OnExitDUISetup
FunctionEnd

Function OnBtnSelectDir
    nsDui::SelectInstallDir
    Pop $0
FunctionEnd

Function OnBtnDirPre
    nsDui::PrePage "wizardTab"
FunctionEnd


# ========================= ��װ���� ===============================

Function CreateShortcut
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\Bin\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\ж��${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\Bin\${EXE_NAME}"
  SetShellVarContext current
FunctionEnd



Function CreateUninstall

	# ����ж�س���
	WriteUninstaller "$INSTDIR\uninst.exe"
	
	# ���ж����Ϣ���������
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
FunctionEnd

# ���һ���յ�Section����ֹ����������
Section "None"
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

FunctionEnd


# ��װ�ɹ��Ժ�.
Function .onInstSuccess

FunctionEnd

# �ڰ�װʧ�ܺ��û������ȡ������ťʱ������.
Function .onInstFailed
    MessageBox MB_ICONQUESTION|MB_YESNO "��װ�ɹ���" /SD IDYES IDYES +2 IDNO +1
FunctionEnd


# ÿ���û����İ�װ·����ʱ����δ��붼�ᱻ����һ��.
Function .onVerifyInstDir

FunctionEnd

# ж�ز�����ʼǰ.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "��ȷ��Ҫж��${PRODUCT_NAME}��?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# ж�سɹ��Ժ�.
Function un.onUninstSuccess

FunctionEnd


