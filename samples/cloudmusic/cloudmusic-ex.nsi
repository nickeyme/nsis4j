# 在对网易云音乐安装包进行了美化
# ====================== 自定义宏 ==============================
!define PRODUCT_NAME           "网易云音乐"
!define EXE_NAME               "cloudmusic.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "NetEase"
!define PRODUCT_LEGAL          "NetEase 1999-2014"

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
OutFile "网易云音乐安装扩展.exe"

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
!define mui_icon              "image\logo.ico"
!define MUI_UNICON            "image\un_logo.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "image\modern-header.bmp"
!define MUI_PAGE_HEADER_TEXT "许可证协议"
!define MUI_PAGE_HEADER_SUBTEXT "在安装“网易云音乐”之前，请阅读授权协议。"

# 如果未使用MUI，则可直接使用.onGUIInit
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

# 自定义页面
page custom PageKeyCreate PageKeyLeave

# ========================= 自定义页面 ============================
Var hKeyDlg
Var dlgHeight
Var dlgWidth
Var hLbl
Var hText
Var hBtnNext
Var hImgCtrlBk
Var hImg
 
Function PageKeyCreate
 
    # 获取父窗体大小
    System::Call "*(i0,i0,i0,i0) i.r1"
    System::Call "user32::GetWindowRect(i$HWNDPARENT, i$1)"
    System::Call "*$1(i.r4,i.r5,i.r6,i.r7)"
    
    IntOp $dlgWidth $6 - $4
    IntOp $dlgHeight $7 - $5

     
    # 隐藏父窗体的一些控件
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
 
    # 创建新的子窗体
    nsDialogs::Create /NOUNLOAD 1018
    Pop $hKeyDlg
    ${If} $hKeyDlg == error
        Abort
    ${EndIf}
     
    # 更改子窗体大小和位置
    System::Call "user32::SetWindowPos(i$hKeyDlg,i0,i0,i0,i$dlgWidth,i$dlgHeight,i0x4)"
       
    # 在子窗体中创建控件
       
    ${NSD_CreateLabel} 20 20 100 20 "输入序列号:"
    Pop $hLbl
    SetCtlColors $hLbl ""  transparent
    ${NSD_CreateText} 20 60 150 20 "1234567890"
    Pop $hText
       
    IntOp $R1 $dlgWidth / 2
    IntOp $R2 $dlgHeight - 80
    ${NSD_CreateButton} $R1 $R2 85 20 "下一步"
    Pop $hBtnNext
    ${NSD_OnClick} $hBtnNext btnNextOnClick
       
    ${NSD_AddStyle} $hBtnNext "${BS_BITMAP}"
    System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\btn.bmp", i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
    Pop $1
    SendMessage $hBtnNext ${BM_SETIMAGE} ${IMAGE_BITMAP} $1
       
    ${NSD_CreateBitmap} 0 0 $dlgWidth $dlgHeight ""
    Pop $hImgCtrlBk
    ${NSD_SetImage} $hImgCtrlBk $PLUGINSDIR\key_bg.bmp $hImg
       
      # 显示子窗体
    nsDialogs::Show
     
    ${NSD_FreeImage} $hImg
FunctionEnd
 
Function PageKeyLeave
    # 还原父窗体样式以及控件的状态
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_SHOW}
    GetDlgItem $1 $HWNDPARENT 2
    ShowWindow $1 ${SW_SHOW}
FunctionEnd
 
Function btnNextOnClick
    ${NSD_GetText} $hText $R1
    MessageBox MB_ICONQUESTION|MB_OK "输入的序列号为:$R1" /SD IDOK
     
    # 向“下一步”按钮发送BM_CLICK消息
    GetDlgItem $0 $HWNDPARENT 1
    SendMessage $0 0x00F5 0 0  
FunctionEnd




# 安装程序欢迎页面
!define MUI_WELCOMEPAGE_TITLE "欢迎使用“网易云音乐”安装向导"
!define MUI_WELCOMEPAGE_TEXT  "这个向导将指引你完成“网易云音乐”的安装进程。$\n$\n在开始安装之前，建议先关闭其他所有应用程序。这将允许“安装程序”更新指定的系统文件，而不需要重新启动你的计算机。$\n$\n单击[下一步(N)]继续。"
!define MUI_WELCOMEFINISHPAGE_BITMAP "image\modern-wizard.bmp"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW welcomePageShow
!insertmacro MUI_PAGE_WELCOME



Function welcomePageShow
    # 设置字体
    CreateFont $0 "微软雅黑" 12 700
    # 在这里如果使用：
    # FindWindow $0 "#32770" "" $HWNDPARENT
    # GetDlgItem $1 $0 0x4B1
    # 会在“上一步”再次显示该页面时获取不到句柄，因为之前的#32770子对话框还没销毁，这时父窗口上有两个#32770子对话框。
    # 采用如下2个解决方法：
    # 1. 使用mui.WelcomePage.Title变量，该变量定义在C:\Program Files (x86)\NSIS\Contrib\Modern UI 2\Pages\Welcome.nsh
     SetCtlColors $mui.WelcomePage.Title 0xB00B0A "${MUI_BGCOLOR}"
     SendMessage $mui.WelcomePage.Title ${WM_SETFONT} $0 0
    
    # 2. 使用FindWindow查找2次
    # FindWindow $1 "#32770" "" $HWNDPARENT
    # FindWindow $1 "#32770" "" $HWNDPARENT $1
    # ${If} $1 == 0
    #     FindWindow $1 "#32770" "" $HWNDPARENT
    # ${EndIf}
    # GetDlgItem $2 $1 0x4B1
    # SetCtlColors $2 0xB00B0A transparent
    # SendMessage $2 ${WM_SETFONT} $0 0

    # 改变控件大小
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
    
    
    # 设置各控件背景透明
    !insertmacro SetTransparent $0 0x4B1 0xB00B0A
    !insertmacro SetTransparent $0 0x4B2 0
FunctionEnd

# 安装程序软件授权申明
!define MUI_LICENSEPAGE_TEXT_TOP ""
!define MUI_LICENSEPAGE_TEXT_BOTTOM "如果你接受协议中的条款，单击 [我接受(I)] 继续安装。如果你选定 [取消(C)] ，安装程序将会关闭。必须接受协议才能安装“网易云音乐”。"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW licensePageShow
!insertmacro MUI_PAGE_LICENSE "license.rtf"

Function licensePageShow
    SetCtlColors $HWNDPARENT 0xFFFFFF 0xF0F0F0
FunctionEnd


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
    !insertmacro TerminateProcess "${EXE_NAME}"
FunctionEnd

Function onGUIInit
    File /oname=$PLUGINSDIR\key_bg.bmp "image\key_bg.bmp"
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


