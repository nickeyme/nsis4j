# nsis4j
fork from https://gitee.com/china_jeffery/nsis4j

- 之前我们通过 `NSIS` 来包装成普通界面安装包，那我们在软件市场上看到那些靓丽的界面安装界面是怎么来的，基于`Duilib`的软件不完全列表

    |公司|产品|
    |-----|------|
    |百度|PPS 爱奇艺 百度杀毒 百度卫士 91助手
    |腾讯|微信 企业微信
    |阿里|钉钉 支付宝安全控件 PP助手 优酷
    |新东方|云教室RoomBox
    |网易|易信 云音乐 荒野行动PC版
    |华为|华为网盘
    |金山|金山快盘
    |京东|咚咚
    |酷我|酷我音乐盒
    |火绒|火绒安全软件
    |墨迹风云|墨迹天气

- 现在我们通过 `NSIS` 和 `Duilib` 来实现自定义安装界面

  - `NSIS` 用于实现安装逻辑
  - `Duilib` 用于实现UI界面
  - 通过`NSIS`调用 `duilib` 生成的dll库来实现

- 生成安装包

  - 克隆 <https://gitee.com/china_jeffery/nsis4j>
  - 编译出 nsDui.dll 放到 `NSIS` 的 `Plugins` 目录
  - 编译 samples\qq\qq.nsi 输出安装包

- [NSISDialogDesigner 工具](http://coolsoft.altervista.org/en/nsisdialogdesigner)

    NSIS Dialog Designer is an IDE that provides a graphical tool to easily design your custom setup pages for the great NSIS installer system.  

以上未经测试也没有制作自己的`UI`皮肤

- [普通自定义页面](https://gist.github.com/johncf/e8f2fc74bec337ddaba30399907d9d9a)

  ```sh
  !include nsDialogs.nsh
  !include LogicLib.nsh
  !include MUI2.nsh

  Name nsDialogs
  OutFile nsDialogs.exe
  RequestExecutionLevel user
  ShowInstDetails show

  Var Dialog
  Var TextUser
  Var TextPass
  Var TextDbName
  Var TextPgDir

  Page custom pgPageCreate pgPageLeave
  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_LANGUAGE "English"

  Function pgPageCreate
      !insertmacro MUI_HEADER_TEXT "Database Settings" "Provide PostgreSQL config and install directory."

      nsDialogs::Create 1018
      Pop $Dialog

      ${If} $Dialog == error
          Abort
      ${EndIf}

      ${NSD_CreateGroupBox} 10% 10u 80% 62u "PostgreSQL Database Settings"
      Pop $0

          ${NSD_CreateLabel} 20% 26u 20% 10u "Username:"
          Pop $0

          ${NSD_CreateText} 40% 24u 40% 12u "postgres"
          Pop $TextUser

          ${NSD_CreateLabel} 20% 40u 20% 10u "Password:"
          Pop $0

          ${NSD_CreatePassword} 40% 38u 40% 12u ""
          Pop $TextPass

          ${NSD_CreateLabel} 20% 54u 20% 10u "New Database:"
          Pop $0

          ${NSD_CreateText} 40% 52u 40% 12u "mydb"
          Pop $TextDbName

      ${NSD_CreateGroupBox} 5% 86u 90% 34u "PostgreSQL Install Path"
      Pop $0

          ${NSD_CreateDirRequest} 15% 100u 49% 12u "$PROGRAMFILES64\PostgreSQL\10"
          Pop $TextPgDir

          ${NSD_CreateBrowseButton} 65% 100u 20% 12u "Browse..."
          Pop $0
          ${NSD_OnClick} $0 OnDirBrowse

      nsDialogs::Show
  FunctionEnd

  Function OnDirBrowse
      ${NSD_GetText} $TextPgDir $0
      nsDialogs::SelectFolderDialog "Select Postgres Directory" "$0"
      Pop $0
      ${If} $0 != error
          ${NSD_SetText} $TextPgDir "$0"
      ${EndIf}
  FunctionEnd

  Function PgPageLeave
      ${NSD_GetText} $TextUser $0
      ${NSD_GetText} $TextPass $1
      ${NSD_GetText} $TextDbName $2
      ${NSD_GetText} $TextPgDir $3
      MessageBox MB_OK "User: $0, Pass: $1, Db: $2, PgDir: $3"
  FunctionEnd

  Section
      DetailPrint "Hello, World!"
  SectionEnd
  ```

  ![自定义界面](https://s1.ax1x.com/2020/09/04/wFGDwd.png)