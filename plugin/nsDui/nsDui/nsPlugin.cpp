#include <windows.h>
#include <commctrl.h>
#include <Shlobj.h>
#include "plugin-common.h"
#include "DlgMain.h"

#pragma comment(lib,"Shell32.lib")

HINSTANCE g_hInstance;
HWND g_hwndParent;
extra_parameters *g_pluginParms = NULL;
CDlgMain *g_pMainDlg = NULL;
std::map<HWND, WNDPROC> g_windowInfoMap;
CDuiString g_progressCtrlName = _T("");
CDuiString g_tabLayoutCtrlName = _T("");
bool g_bMSGLoopFlag = true;



#define NSMETHOD_INIT(parent) {\
        g_pluginParms = extra; \
        g_hwndParent = parent; \
        EXDLL_INIT(); }

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
    g_hInstance = (HINSTANCE)hInst;

    if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
        //do what you want at init time.
    }

    if (ul_reason_for_call == DLL_THREAD_DETACH || ul_reason_for_call == DLL_PROCESS_DETACH) {
        //clean up code.
    }

    return TRUE;
}

// NSIS插件导出函数,NSIS规定函数声明格式如下：
extern "C" __declspec(dllexport) void __cdecl
add ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        // == 添加自己代码
        int i = popint();
        int j = popint();
        int k = i + j;
        pushint(k);
        // ==
    }
}

extern "C" __declspec(dllexport) void __cdecl
GetDialogSize ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        HWND hwnd = (HWND)popint();
        RECT rect;
        ::GetWindowRect(hwnd, &rect);

        pushint(rect.bottom - rect.top);
        pushint(rect.right - rect.left);
    }
}

extern "C" __declspec(dllexport) void __cdecl
GetDialogStyle ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        HWND hwnd = (HWND)popint();
        int style = (int)::GetWindowLongA(hwnd, GWL_STYLE);
        pushint(style);
    }
}

extern "C" __declspec(dllexport) void __cdecl
GetSetupPath ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char buf[512] = {0};
        ::GetModuleFileName(NULL, buf, 512);
        pushstring(buf);
    }
}

extern "C" __declspec(dllexport) void __cdecl
Trace ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char buf[1024] = {0};
        popstring(buf);
        DUI__Trace(_T("NSISHelper Trace:%s"), buf);
    }
}

extern "C" __declspec(dllexport) void __cdecl
GetCtrlPos ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        HWND hwnd = (HWND)popint();
        RECT rect;
        GetClientRect(hwnd, &rect);
        DUI__Trace(_T("%d %d %d %d %d"), hwnd, rect.left, rect.top, rect.right, rect.bottom);

        POINT lt = {rect.left, rect.top};
        POINT rb = {rect.right, rect.bottom};

        ::ClientToScreen(hwndParent, &lt);
        ::ClientToScreen(hwndParent, &rb);

        pushint(rb.y);
        pushint(rb.x);
        pushint(lt.y);
        pushint(lt.x);
    }
}


// =========================================== DUILIB =============================================

NSISAPI FindControl(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    char controlName[MAX_PATH];
    ZeroMemory(controlName, MAX_PATH);

    popstring( controlName );
    CControlUI *pControl = static_cast<CControlUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl( controlName ));

    if( pControl == NULL )
        pushint( - 1 );

    pushint( 0 );
}

NSISAPI  OnControlBindNSISScript(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    char controlName[MAX_PATH];
    ZeroMemory(controlName, MAX_PATH);

    popstring(controlName);
    int callbackID = popint();
    g_pMainDlg->SaveToControlCallbackMap( controlName, callbackID );
}

NSISAPI ExitDUISetup(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    ExitProcess(0);
}


static UINT_PTR PluginCallback(enum NSPIM msg)
{
    return 0;
}

NSISAPI InitDUISetup( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    extra->RegisterPluginCallback(g_hInstance, PluginCallback);
    {
        CPaintManagerUI::SetInstance(g_hInstance);
        char buf[512] = {0};
        ::GetModuleFileName(NULL, buf, 512);
        int len = strlen(buf);
        --len;

        while(len >= 0) {
            if(buf[len] == '\\')
                break;

            buf[len] = '\0';
            --len;
        }

        sprintf_s(buf, "%sskin", buf);

        //CPaintManagerUI::SetResourcePath(buf);
        g_pMainDlg = new CDlgMain();
        g_pMainDlg->Create(NULL, _T("腾讯QQ安装向导"), UI_WNDSTYLE_FRAME, WS_EX_STATICEDGE | WS_EX_APPWINDOW, 0, 0, 600, 800);
        g_pMainDlg->CenterWindow();
        g_pMainDlg->ShowWindow(FALSE);
        pushint(int(g_pMainDlg->GetHWND()));

    }
}

NSISAPI ShowPage ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        g_pMainDlg->ShowWindow(true);
        //CPaintManagerUI::MessageLoop();
        MSG msg = { 0 };
        while( ::GetMessage(&msg, NULL, 0, 0) && g_bMSGLoopFlag ) 
        {
            ::TranslateMessage(&msg);
            ::DispatchMessage(&msg);
        }
    }
}

NSISAPI GetCheckboxStatus ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char pszName[512] = {0};

        popstring(pszName);
        CCheckBoxUI *pChbAgree = static_cast<CCheckBoxUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl(pszName));
        if(!pChbAgree) {
            pushint(-1);
            return;
        }
        DUI__Trace("%s status:%d",pszName,pChbAgree->GetCheck()?1:0);
        pushint(pChbAgree->GetCheck()?1:0);
    }
}

NSISAPI NextPage ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char pszTabName[512] = {0};

        popstring(pszTabName);

        CTabLayoutUI *pTabLayout = static_cast<CTabLayoutUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl(pszTabName));

        if( pTabLayout) {
            int currentIndex = pTabLayout->GetCurSel();
            pTabLayout->SelectItem(currentIndex+1);
        }
    }
}


NSISAPI PrePage ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char pszTabName[512] = {0};

        popstring(pszTabName);

        CTabLayoutUI *pTabLayout = static_cast<CTabLayoutUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl(pszTabName));

        if( pTabLayout) {
            int currentIndex = pTabLayout->GetCurSel();
            pTabLayout->SelectItem(currentIndex-1);
        }
    }
}

NSISAPI SetSliderRange ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char buf[512] = {0};
        popstring( buf );
        int iMin = popint();
        int iMax = popint();

        CProgressUI *pProgress = static_cast<CProgressUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl( buf ));

        if( pProgress == NULL )
            return;

        pProgress->SetMaxValue(iMax);
        pProgress->SetMinValue(iMin);
    }
}

NSISAPI SetSliderValue ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char buf[512] = {0};
        popstring( buf );
        int iValue = popint();

        CProgressUI *pProgress = static_cast<CProgressUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl( buf ));

        if( pProgress)
            pProgress->SetValue(iValue);
    }
}

NSISAPI SetDirValue ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        char buf[512] = {0};
        popstring( buf );
        CEditUI *pEdit = static_cast<CEditUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl("editDir"));
        if(pEdit)
            pEdit->SetText(buf);
    }
}

NSISAPI GetDirValue ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        CDuiString strFolderPath;
        CEditUI *pEdit = static_cast<CEditUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl("editDir"));
        if(pEdit)
            strFolderPath = pEdit->GetText();

        pushstring((char*)strFolderPath.GetData());
    }
}

NSISAPI SelectInstallDir ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        BROWSEINFO bi;
        memset(&bi, 0, sizeof(BROWSEINFO));

        bi.hwndOwner = g_pMainDlg->GetHWND();
        bi.lpszTitle = "选择安装路径";
        bi.ulFlags = 0x0040 ; 

        char szFolderPath[MAX_PATH] = {0};
        LPITEMIDLIST idl = SHBrowseForFolder(&bi);
        if(idl == NULL)
        {
            pushstring(szFolderPath);
            return;
        }

        SHGetPathFromIDList(idl, szFolderPath);

        CEditUI *pEdit = static_cast<CEditUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl("editDir"));
        if(pEdit)
            pEdit->SetText(szFolderPath);

        pushstring(szFolderPath);
    }
}



//NSISAPI StartInstall ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
//{
//    NSMETHOD_INIT(hwndParent);
//    {
//        g_bMSGLoopFlag = false;
//    }
//}
//
//BOOL CALLBACK PluginNewWindowProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
//{
//    BOOL res = 0;
//    std::map<HWND, WNDPROC>::iterator iter = g_windowInfoMap.find( hwnd );
//
//    if( iter != g_windowInfoMap.end() ) {
//        if (message == WM_NCCREATE || message == WM_CREATE || message == WM_PAINT || message== WM_NCPAINT) {
//            ShowWindow( hwnd, SW_HIDE );
//        } else if( message == LVM_SETITEMTEXT ) {
//            ;
//        } else if( message == PBM_SETPOS ) {
//            CProgressUI *pProgress = static_cast<CProgressUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl( g_progressCtrlName ));
//
//            if( pProgress == NULL )
//                return 0;
//
//            pProgress->SetMaxValue( 30000 );
//            pProgress->SetValue( (int)wParam);
//
//            if( pProgress->GetValue() == 30000 ) {
//                CTabLayoutUI *pTab = static_cast<CTabLayoutUI *>(g_pMainDlg->GetPaintManagerUI()->FindControl( g_tabLayoutCtrlName ));
//                if( pTab == NULL )
//                    return -1;
//
//                int currentIndex = pTab->GetCurSel();
//                DUI__Trace("tabName:%s index:%d",g_tabLayoutCtrlName,currentIndex);
//                pTab->SelectItem(2);
//                
//            }
//        } else {
//            res = CallWindowProc( iter->second, hwnd, message, wParam, lParam);
//        }
//    }
//
//    return res;
//}



//NSISAPI BindProgressControl ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
//{
//    NSMETHOD_INIT(hwndParent);
//    {
//        char buf[512] = {0};
//        popstring( buf );
//        g_progressCtrlName = buf;
//
//        memset(buf, 0, 512);
//        popstring(buf);
//        g_tabLayoutCtrlName = buf;
//
//        // 接管page instfiles的消息.
//        g_windowInfoMap[hwndParent] = (WNDPROC) SetWindowLong(hwndParent, GWL_WNDPROC, (long) PluginNewWindowProc);
//        HWND hProgressHWND = FindWindowEx( FindWindowEx( hwndParent, NULL, _T("#32770"), NULL ), NULL, _T("msctls_progress32"), NULL );
//        g_windowInfoMap[hProgressHWND] = (WNDPROC) SetWindowLong(hProgressHWND, GWL_WNDPROC, (long) PluginNewWindowProc);
//        HWND hInstallDetailHWND = FindWindowEx( FindWindowEx( hwndParent, NULL, _T("#32770"), NULL ), NULL, _T("SysListView32"), NULL );
//        g_windowInfoMap[hInstallDetailHWND] = (WNDPROC) SetWindowLong(hInstallDetailHWND, GWL_WNDPROC, (long) PluginNewWindowProc);
//    }
//}