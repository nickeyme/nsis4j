#include <windows.h>
#include <commctrl.h>
#include <stdarg.h>
#include <tchar.h>
#include "plugin-common.h"


HINSTANCE g_hInstance;
HWND g_hwndParent;
extra_parameters *g_pluginParms = NULL;

void TraceMsg(const TCHAR * lpFormat,...) {
    if(!lpFormat)
        return;

    TCHAR buf[PLUGIN_BUF_LEN] = {0};
    va_list arglist;

    va_start(arglist, lpFormat);
    _vsntprintf_s(buf, _countof(buf), lpFormat, arglist);
    va_end(arglist);

    OutputDebugString(buf);
}


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
Trace ( HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)
{
    NSMETHOD_INIT(hwndParent);
    {
        TCHAR buf[PLUGIN_BUF_LEN] = {0};
        popstring(buf);
        TraceMsg(buf);
    }
}
