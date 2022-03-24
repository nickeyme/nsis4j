#ifndef __DLG_MAIN_H__
#define __DLG_MAIN_H__
#include "UIlib.h"
using namespace DuiLib;
#include "plugin-common.h"
#include "resource.h"

extern extra_parameters* g_pluginParms;

class CDlgMain: public WindowImplBase
{
public:
    CDlgMain();
    ~CDlgMain();

protected:
    virtual LPCTSTR GetWindowClassName() const {return _T("CDlgMain");};
    virtual CDuiString GetSkinFolder() { return _T(""); }
    virtual CDuiString GetSkinFile() { return _T("install.xml"); }
    virtual UILIB_RESOURCETYPE GetResourceType() const { return UILIB_ZIPRESOURCE; }
    virtual LPCTSTR GetResourceID() const { return MAKEINTRESOURCE(IDR_ZIPRES_SKIN); }

    virtual void Notify(TNotifyUI& msg);
    virtual void InitWindow();

    virtual LRESULT HandleCustomMessage(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);

};

#endif