
# ====================== 自定义宏 ==============================
!define PRODUCT_NAME           "腾讯QQ"
!define EXE_NAME               "QQ.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "Tencent"
!define PRODUCT_LEGAL          "Copyright (C) 1999-2014 Tencent, All Rights Reserved"


# ===================== 外部插件以及宏 =============================
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "..\..\include\common.nsh"

# ===================== 安装包版本 =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ==================== NSIS属性 ================================

#SetCompressor zlib

; 安装包名字.
Name "${PRODUCT_NAME}"

# 安装程序文件名.
OutFile "QQ Setup.exe"

# 默认安装位置.
InstallDir "$PROGRAMFILES\Tencent\${PRODUCT_NAME}"


# 针对Vista和win7 的UAC进行权限请求.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

# 安装和卸载程序图标
Icon              "image\logo.ico"
UninstallIcon     "image\logo.ico"



# 自定义页面
Page custom DUIPage


# 卸载程序显示进度
UninstPage instfiles

# ======================= DUILIB 自定义页面 =========================
Var hInstallDlg

Function DUIPage
    !insertmacro Trace "$TEMP $PLUGINSDIR"
    nsDui::InitDUISetup
    Pop $hInstallDlg
    
    # License页面
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
    
    # 目录选择 页面
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
    

    
    # 安装进度 页面
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

    # 安装完成 页面
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

# 开始安装
Function OnBtnInstall
    nsDui::GetDirValue
    Pop $0
    StrCmp $0 "" InstallAbort 0
    StrCpy $INSTDIR "$0"
    nsDui::NextPage "wizardTab"
    nsDui::SetSliderRange "slrProgress" 0 100
    
    # 覆盖安装时，指定不覆盖的文件
    # 将这些文件暂存到临时目录
    CreateDirectory "$TEMP\qq_file_translate"
    CopyFiles /SILENT "$INSTDIR\gf-config.xml" "$TEMP\qq_file_translate"
    
    #启动一个低优先级的后台线程
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
    
    # 文件释放完成以后，还原暂存的文件
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
    # 开机启动
    nsDui::GetCheckboxStatus "chkBootStart"
    Pop $R0
    ${If} $R0 == "1"
        SetShellVarContext all
        CreateShortCut "$SMSTARTUP\QQ.lnk" "$INSTDIR\Bin\QQ.exe"
    ${EndIf}
    
    # 立即启动
    nsDui::GetCheckboxStatus "chkStartNow"
    Pop $R0
    ${If} $R0 == "1"
        Exec "$INSTDIR\Bin\QQ.exe"
    ${EndIf}
    
    # 设置主页
    nsDui::GetCheckboxStatus "chkSetHomePage"
    Pop $R0
    ${If} $R0 == "1"
        WriteRegStr HKCU "Software\Microsoft\Internet Explorer\Main" "Start Page" "http://www.qq.com"
    ${EndIf}
    
    # 显示新特征
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


# ========================= 安装步骤 ===============================

Function CreateShortcut
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\Bin\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\Bin\${EXE_NAME}"
  SetShellVarContext current
FunctionEnd



Function CreateUninstall

	# 生成卸载程序
	WriteUninstaller "$INSTDIR\uninst.exe"
	
	# 添加卸载信息到控制面板
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
FunctionEnd

# 添加一个空的Section，防止编译器报错
Section "None"
SectionEnd


# 卸载区段
Section "Uninstall"

  ; 删除快捷方式
  SetShellVarContext all
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}\"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  SetShellVarContext current
  
  SetOutPath "$INSTDIR"

  ; 删除安装的文件
  Delete "$INSTDIR\*.*"

  SetOutPath "$DESKTOP"

  RMDir /r "$INSTDIR"
  RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd





# ============================== 回调函数 ====================================

# 函数名以“.”开头的一般作为回调函数保留.
# 函数名以“un.”开头的函数将会被创建在卸载程序里，因此，普通安装区段和函数不能调用卸载函数，而卸载区段和卸载函数也不能调用普通函数。

Function .onInit

FunctionEnd


# 安装成功以后.
Function .onInstSuccess

FunctionEnd

# 在安装失败后用户点击“取消”按钮时被调用.
Function .onInstFailed
    MessageBox MB_ICONQUESTION|MB_YESNO "安装成功！" /SD IDYES IDYES +2 IDNO +1
FunctionEnd


# 每次用户更改安装路径的时候这段代码都会被调用一次.
Function .onVerifyInstDir

FunctionEnd

# 卸载操作开始前.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "您确定要卸载${PRODUCT_NAME}吗?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# 卸载成功以后.
Function un.onUninstSuccess

FunctionEnd


