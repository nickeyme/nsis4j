#ifndef __UI_ANIMATION_H__
#define __UI_ANIMATION_H__

#include "UIAnimation.h"
#include "UILabel.h"

namespace DuiLib
{
    class UILIB_API CImageShowUI: public CUIAnimation, public CLabelUI
    {
    public:
        CImageShowUI();
        virtual ~CImageShowUI();
        virtual LPCTSTR GetClass() const;
        virtual LPVOID GetInterface(LPCTSTR pstrName);
        virtual void SetAttribute(LPCTSTR pstrName, LPCTSTR pstrValue);
    protected:
        virtual void DoEvent(TEventUI& event);
        virtual void OnAnimationStart(INT nAnimationID, BOOL bFirstLoop) {}
        virtual void OnAnimationStep(INT nTotalFrame, INT nCurFrame, INT nAnimationID);
        virtual void OnAnimationStop(INT nAnimationID) {}
        
        virtual void DoInit();

    private:
        int m_iImgCount;
        vector<CDuiString> m_arImgNames;
    };
}

#endif