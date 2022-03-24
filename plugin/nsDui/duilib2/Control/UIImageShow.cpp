#include "StdAfx.h"
#include "UIImageShow.h"

namespace DuiLib {
    CImageShowUI::CImageShowUI():
        CUIAnimation(&(*this))
    {
    }

    CImageShowUI::~CImageShowUI()
    {
        StopAnimation();
    }

    LPCTSTR CImageShowUI::GetClass() const
    {
        return _T("ImageShow");
    }

    LPVOID CImageShowUI::GetInterface( LPCTSTR pstrName )
    {
        if( _tcscmp(pstrName, DUI_CTR_IMAGESHOW) == 0 )
            return static_cast<CImageShowUI*>(this);
        return CLabelUI::GetInterface(pstrName);
    }

    void CImageShowUI::DoEvent( TEventUI& event )
    {
        if( event.Type == UIEVENT_TIMER ) 
        {
            OnAnimationElapse(event.wParam);
        }
        CLabelUI::DoEvent( event );
    }

    void CImageShowUI::OnAnimationStep( INT nTotalFrame, INT nCurFrame, INT nAnimationID )
    {
        if(nCurFrame < m_arImgNames.size()) {
            CDuiString strImg = m_arImgNames.at(nCurFrame);
            CLabelUI::SetBkImage(strImg.GetData());
            Invalidate();
        }
    }

    void CImageShowUI::SetAttribute( LPCTSTR pstrName, LPCTSTR pstrValue )
    {
        if(_tcscmp(pstrName, _T("imagecount")) == 0 ) {
            m_iImgCount = _ttoi(pstrValue);
        } else if(_tcscmp(pstrName, _T("images"))==0) {
            TCHAR * token = _tcstok((TCHAR*)pstrValue, _T(" "));
            while(token) {
                m_arImgNames.push_back(token);
                token = _tcstok(NULL, _T(" "));
            }
        } else if(_tcscmp(pstrName, _T("loop"))==0) {
            if(_tcscmp(pstrValue, _T("true"))==0)
                SetLoopShow(TRUE);
            else if(_tcscmp(pstrValue, _T("true"))==0)
                SetLoopShow(FALSE);
        } else {
            CLabelUI::SetAttribute(pstrName, pstrValue);
        }
    }

    void CImageShowUI::DoInit()
    {
        CDuiString strImg = m_arImgNames.at(0);
        CLabelUI::SetBkImage(strImg.GetData());
        StartAnimation(1500, m_iImgCount, 0, TRUE);
        SetCurrentFrame(1);
    }
}

