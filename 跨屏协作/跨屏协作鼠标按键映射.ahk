#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;;kMiScreenShareMainWindow


#IfWinActive ahk_class kMiScreenShareMainWindow
    RButton::
        WinGetPos,,,Wi,He,A
        Wi-=100
        He-=40
        ControlClick,x%Wi% y%He%,A
    return
    MButton::
        WinGetPos,,,Wi,He,A
        Wi/=2
        He-=40
        ControlClick,x%Wi% y%He%,A
    return
    ^LButton::
        MouseGetPos, xpos, ypos
        if(xpos<309||ypos<754){
            msgbox 窗口不得小于309x754
            return
        }
        WinGetPos,,,Wi,He,A
        ;msgbox  %xpos% %Wi%
        xpos*=100/Wi
        ypos*=100/He
        p :=xpos<ypos?xpos:ypos
        WinMove,A,,,,Wi*p/100,He*p/100
        Wi-=95
        ControlClick,x%Wi% y30,A
        Sleep, 100
        WinGetPos,,,Wi,,A
        Wi-=95
        ControlClick,x%Wi% y30,A
    return

return