#include "DlgMain.h"


CDlgMain::CDlgMain()
{
}

CDlgMain::~CDlgMain()
{

}

void CDlgMain::Notify( TNotifyUI& msg )
{
    std::map<CDuiString, int >::iterator iter = m_controlCallbackMap.find( msg.pSender->GetName() );
    if( _tcsicmp( msg.sType, _T("click") ) == 0 ){
        if( iter != m_controlCallbackMap.end() )
            g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );
    }
    else if( _tcsicmp( msg.sType, _T("textchanged") ) == 0 ){
        if( iter != m_controlCallbackMap.end() )
            g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );
    } else {
        WindowImplBase::Notify(msg);
    }
}

LRESULT CDlgMain::HandleCustomMessage( UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled )
{
    return 0;
}

void CDlgMain::InitWindow()
{
    CRichEditUI * pRichEdit = static_cast<CRichEditUI*>(m_PaintManager.FindControl(_T("editLicense")));
    if(pRichEdit) {
        HRSRC hRsrc = FindResourceA(CPaintManagerUI::GetInstance(), MAKEINTRESOURCEA(IDR_TEXT_LICENSE), "TEXT");
        if(!hRsrc)
            return;

        DWORD dwSize = SizeofResource(CPaintManagerUI::GetInstance(), hRsrc);
        if(dwSize==0)
            return;

        HGLOBAL hGlobal = LoadResource(CPaintManagerUI::GetInstance(), hRsrc);
        if(!hGlobal)
            return;

        LPVOID lpBuffer = LockResource(hGlobal);
        if(!lpBuffer)
            return;

        pRichEdit->AppendText((char*)lpBuffer);

        FreeResource(hGlobal);
    }
}










