
# ====================== 自定义宏 ==============================
!define PRODUCT_NAME           "NSIS Plugin Demo"
!define EXE_NAME               "360Safe.exe"
!define PRODUCT_VERSION        "1.0.0.1"
!define PRODUCT_PUBLISHER      "None"
!define PRODUCT_LEGAL          "*** 1999-2014"
!define TEMP_DIR               "e:\temp"

# ===================== 定义全局变量 ===========================
Var paramInstllDir      # 启动参数-安装目录


# ===================== 外部插件以及宏 =============================
!include "MUI2.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!insertmacro GetParameters
!insertmacro GetOptions

# ===================== 安装包版本 =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ==================== NSIS属性 ================================
; 安装包名字.
Name "${PRODUCT_NAME}"

# 安装程序文件名.
OutFile "nsis-demo.exe"

# 默认安装位置.
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

# 设置显示在安装窗口底部的文本(默认为“Nullsoft Install System vX.XX”).
BrandingText "${PRODUCT_PUBLISHER}"

# 设置是否显示安装详细信息。
ShowInstDetails show

# 设置是否显示卸载详细信息
ShowUnInstDetails   show

# 针对Vista和win7 的UAC进行权限请求.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel highest

# 静默安装
;SilentUnInstall silent
;SilentInstall silent

# ==================== MUI属性 ==================================
# 安装和卸载程序图标
!define MUI_ICON              "logo.ico"
!define MUI_UNICON            "logo.ico"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

# 自定义页面
Page custom DUIPage
page custom KeyPageCreate KeyPageLeave

# 安装程序欢迎页面
!define MUI_WELCOMEPAGE_TITLE "欢迎使用×××软件安装向导"
!define MUI_WELCOMEPAGE_TEXT  "该向导将引导您完成×××软件的安装。"
!insertmacro MUI_PAGE_WELCOME

# 安装程序软件授权申明
!insertmacro MUI_PAGE_LICENSE "readme.rtf"

# 安装程序显示安装组件选择
!insertmacro MUI_PAGE_COMPONENTS

# 安装程序显示安转目录选择
!define MUI_PAGE_CUSTOMFUNCTION_SHOW dirPageShow  # 在页面显示之前执行
!insertmacro MUI_PAGE_DIRECTORY

Function dirPageShow
    MessageBox MB_ICONQUESTION|MB_OK "安装目录选择" /SD IDOK
FunctionEnd


# 安装程序显示进度
!insertmacro MUI_PAGE_INSTFILES

# 安装程序显示安装结束
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "安装完成以后启动应用程序"
!insertmacro MUI_PAGE_FINISH

# 卸载程序显示进度
!insertmacro MUI_UNPAGE_INSTFILES

# 卸载程序显示安装结束
!insertmacro MUI_UNPAGE_FINISH

# 指定语言，必须在最后指定
!insertmacro MUI_LANGUAGE "SimpChinese"


# ========================= 自定义页面 ============================
Var hKeyDlg
Var dlgHeight
Var dlgWidth
Var hLbl
Var hText
Var hBtnNext
Var hImgCtrlBk
Var hImg


Function KeyPageCreate

    # 获取父窗体大小
    NSISHelper::GetDialogSize $HWNDPARENT
    Pop $dlgWidth
    Pop $dlgHeight
    
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
	  ${NSD_SetImage} $hImgCtrlBk $PLUGINSDIR\bg.bmp $hImg
	  
	  # 显示子窗体
    nsDialogs::Show
    
    ${NSD_FreeImage} $hImg
FunctionEnd

Function KeyPageLeave
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

# ======================= DUILIB 自定义页面 =========================
Var hDUIDlg

Function DUIPage
    NSISHelper::InitDUISetup
    Pop $hDUIDlg
    
    #绑定函数-关闭按钮
    NSISHelper::FindControl "btnClose"
    Pop $0
    ${If} $0 == 0
        GetFunctionAddress $0 OnExitDUISetup
        NSISHelper::OnControlBindNSISScript "btnClose" $0
    ${EndIf}
    
    #绑定函数-下一步按钮
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



# ========================= 安装步骤 ===============================

# 区段1
# 区段名以一个 ! 开头，那么该区段的显示名称将以粗体字显示.
Section "!Files" "des_files"

  ; 设置文件的输出路径
  SetOutPath $INSTDIR
  
  ; 放置文件
  File "app\DuiLib_ud.dll"
  File "app\${EXE_NAME}"
  
  SetOutPath "$INSTDIR\skin"
  File /r /x *.svn "app\skin\"
  
SectionEnd


# 区段2
Section "Shortcut" "des_shortcut"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
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


# ============================= 自定义函数或宏 =====================================
# 解析启动参数
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

# 终止进程
Function TerminateProcess
	# Please see http://nsis.sourceforge.net/KillProcDLL_plug-in
	#            http://nsis.sourceforge.net/ExecCmd_plug-in
again:
	KillProcDLL::KillProc "${EXE_NAME}"
	${If} $R0 == 0 # 终止成功
		goto end
	${ElseIf} $R0 == 603 # 进程不存在
		goto end
	${ElseIf} $R0 == 604 # 无权限
		ExecCmd::exec '"taskkill" /F /IM ${EXE_NAME} /T'
		goto again
	${EndIf}
end:
FunctionEnd


# ============================== 回调函数 ====================================

# 函数名以“.”开头的一般作为回调函数保留.
# 函数名以“un.”开头的函数将会被创建在卸载程序里，因此，普通安装区段和函数不能调用卸载函数，而卸载区段和卸载函数也不能调用普通函数。

Function .onInit
    # 自定义临时目录，使用插件chngvrbl.dll。
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
 
    MessageBox MB_ICONQUESTION|MB_OK "临时目录:$TEMP" 

    File /oname=$PLUGINSDIR\bg.bmp "bg.bmp"
    File /oname=$PLUGINSDIR\btn.bmp "btn.bmp"
    
    !insertmacro ParseParameters 
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
    MessageBox MB_ICONQUESTION|MB_YESNO "确定要卸载吗?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

# 卸载成功以后.
Function un.onUninstSuccess
    MessageBox MB_ICONQUESTION|MB_OK "卸载成功!" /SD IDOK
FunctionEnd


