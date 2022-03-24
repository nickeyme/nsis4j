
# ====================== 自定义宏 ==============================
!define PRODUCT_NAME           "网易云音乐"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"
!define TEMP_DIR               ""


# ===================== 外部插件以及宏 =============================
!include "MUI2.nsh"


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
# ZLIB(默认) BZIP2 LZMA 
SetCompressor lzma

; 安装包名字.
Name "${PRODUCT_NAME}"

# 安装程序文件名.
OutFile "网易云音乐安装0.exe"

# 默认安装位置.
InstallDir "$PROGRAMFILES\Netease\CloudMusic"


# 设置是否显示安装详细信息。
ShowInstDetails hide

# 设置是否显示卸载详细信息
ShowUnInstDetails   hide

# 针对Vista和win7 的UAC进行权限请求.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin


# ==================== MUI属性 ==================================
# 安装和卸载程序图标
!define MUI_ICON              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"


# 如果未使用MUI，则可直接使用.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit


# 安装程序欢迎页面
!insertmacro MUI_PAGE_WELCOME

# 安装程序软件授权申明页面
!insertmacro MUI_PAGE_LICENSE "license.rtf"


# 安装程序显示安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY

# 安装程序显示安装组件选择页面
!insertmacro MUI_PAGE_COMPONENTS

# 安装程序显示进度页面
!insertmacro MUI_PAGE_INSTFILES

# 安装程序显示安装结束页面
!insertmacro MUI_PAGE_FINISH


# 卸载程序显示进度
!insertmacro MUI_UNPAGE_INSTFILES

# 卸载程序显示安装结束
!insertmacro MUI_UNPAGE_FINISH

# 指定语言，必须在最后指定
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= 安装步骤 ===============================

# 区段1
# 区段名以一个 ! 开头，那么该区段的显示名称将以粗体字显示.
Section "!Files" "des_files"

  ; 设置文件的输出路径
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


# 区段描述
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${des_files}     "主程序文件"
  !insertmacro MUI_DESCRIPTION_TEXT ${des_shortcut}  "创建开始菜单和桌面快捷方式"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# ============================== 回调函数 ====================================

# 函数名以“.”开头的一般作为回调函数保留.
# 函数名以“un.”开头的函数将会被创建在卸载程序里，因此，普通安装区段和函数不能调用卸载函数，而卸载区段和卸载函数也不能调用普通函数。

Function .onInit
FunctionEnd

Function onGUIInit

FunctionEnd


# 安装成功以后.
Function .onInstSuccess

FunctionEnd


# 卸载操作开始前.
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "你确实要完全删除网易云音乐，及其所有组件吗?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# 卸载成功以后.
Function un.onUninstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} 已成功地从你的计算机移除" /SD IDOK
FunctionEnd


