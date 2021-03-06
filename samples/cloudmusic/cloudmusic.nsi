
# ====================== 自定义宏 ==============================
!define PRODUCT_NAME           "网易云音乐"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"
!define TEMP_DIR               ""

# ===================== 定义全局变量 ===========================



# ===================== 外部插件以及宏 =============================
!include "MUI2.nsh"
!include "LogicLib.nsh"
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
SetCompressor lzma

; 安装包名字.
Name "${PRODUCT_NAME}"

# 安装程序文件名.
OutFile "网易云音乐安装.exe"

# 默认安装位置.
InstallDir "$PROGRAMFILES\Netease\CloudMusic"

# 设置显示在安装窗口底部的文本(默认为“Nullsoft Install System vX.XX”).
BrandingText "网易云音乐 http://music.163.com"

# 设置是否显示安装详细信息。
ShowInstDetails hide

# 设置是否显示卸载详细信息
ShowUnInstDetails   hide

# 针对Vista和win7 的UAC进行权限请求.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

# 静默安装
;SilentUnInstall silent
;SilentInstall silent

# ==================== MUI属性 ==================================
# 安装和卸载程序图标
!define MUI_ICON              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "image\modern-header.bmp"
!define MUI_PAGE_HEADER_TEXT "许可证协议"
!define MUI_PAGE_HEADER_SUBTEXT "在安装“网易云音乐”之前，请阅读授权协议。"

# 如果未使用MUI，则可直接使用.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit


# 安装程序欢迎页面
!define MUI_WELCOMEPAGE_TITLE "欢迎使用“网易云音乐”安装向导"
!define MUI_WELCOMEPAGE_TEXT  "这个向导将指引你完成“网易云音乐”的安装进程。$\n$\n在开始安装之前，建议先关闭其他所有应用程序。这将允许“安装程序”更新指定的系统文件，而不需要重新启动你的计算机。$\n$\n单击[下一步(N)]继续。"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\modern-wizard.bmp"
!insertmacro MUI_PAGE_WELCOME

# 安装程序软件授权申明
!define MUI_LICENSEPAGE_TEXT_TOP ""
!define MUI_LICENSEPAGE_TEXT_BOTTOM "如果你接受协议中的条款，单击 [我接受(I)] 继续安装。如果你选定 [取消(C)] ，安装程序将会关闭。必须接受协议才能安装“网易云音乐”。"
!insertmacro MUI_PAGE_LICENSE "license.rtf"



# 安装程序显示安转目录选择
!define MUI_PAGE_CUSTOMFUNCTION_SHOW dirPageShow  # 在页面显示之前执行
!define MUI_DIRECTORYPAGE_TEXT_TOP "默认将安装在下列文件夹。要安装到不同文件夹，单击[浏览(B)]并选择其他的文件夹。单击[安装(I)]开始安装进程。"
!insertmacro MUI_PAGE_DIRECTORY

Function dirPageShow
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
FunctionEnd


# 安装程序显示进度
!insertmacro MUI_PAGE_INSTFILES

# 安装程序显示安装结束

!define MUI_PAGE_CUSTOMFUNCTION_SHOW finishPageShow
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE finishPageLeave
!define MUI_FINISHPAGE_TITLE "正在完成“网易云音乐”安装向导"
!define MUI_FINISHPAGE_TEXT ""
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "立即运行网易云音乐"
!insertmacro MUI_PAGE_FINISH

Var chbCreateShortcut
Var chbAutoStart


Function finishPageShow
    ${NSD_CreateCheckbox} 120u 110u 239u 15u "开机启动网易云音乐"
	  Pop $chbAutoStart
	  ${NSD_SetState} $chbAutoStart ${BST_CHECKED}
	  SetCtlColors $chbAutoStart "000000" ${MUI_BGCOLOR}
	  
	  ${NSD_CreateCheckbox} 120u 130u 239u 15u "创建桌面快捷方式"
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

# 卸载程序显示进度
!insertmacro MUI_UNPAGE_INSTFILES

# 卸载程序显示安装结束
;!insertmacro MUI_UNPAGE_FINISH

# 指定语言，必须在最后指定
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= 安装步骤 ===============================

# 区段1
# 区段名以一个 ! 开头，那么该区段的显示名称将以粗体字显示.
Section "!Files" "des_files"

    SetOutPath $INSTDIR
  
    ; 放置文件
    File /r "app\*.*"
  
SectionEnd


# 区段2
Section "Shortcut" "des_shortcut"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  SetShellVarContext current
SectionEnd


# 区段3
# 区段名为空、遗漏或者以一个 "-" 开头，那么它将是一个隐藏的区段，用户也不能选择禁止它.
Section "-Necessary"

	# 生成卸载程序
	WriteUninstaller "$INSTDIR\uninst.exe"
	
	# 添加卸载信息到控制面板
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
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
    !insertmacro ChangeTempDir "${TEMP_DIR}"
FunctionEnd

Function onGUIInit
    !insertmacro TerminateProcess "${EXE_NAME}"
FunctionEnd


# 安装成功以后.
Function .onInstSuccess

FunctionEnd

# 在安装失败后用户点击“取消”按钮时被调用.
Function .onInstFailed

FunctionEnd


# 每次用户更改安装路径的时候这段代码都会被调用一次.
Function .onVerifyInstDir
    
FunctionEnd

# 卸载操作开始前.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "你确实要完全删除网易云音乐，及其所有组件吗?" /SD IDYES IDYES +2 IDNO +1
    Abort
    !insertmacro TerminateProcess "${EXE_NAME}"
FunctionEnd

# 卸载成功以后.
Function un.onUninstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} 已成功地从你的计算机移除" /SD IDOK
FunctionEnd


