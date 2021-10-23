;����adb·����������úû�������ֱ���ñ���
global adbc :="adb"

#z::
;MsgBox % Explorer_GetSelection(hwnd)
CheckAdb()
return

Explorer_GetSelection(hwnd="")   
{  
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")  
    WinGetClass class, ahk_id %hwnd%  
    if (process != "explorer.exe")  
        return  
    num :=0
    if (class ~= "Progman|WorkerW") {  
            ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%  
            Loop, Parse, files, `n, `r  
            {
                UpFile( A_Desktop "\" A_LoopField,A_LoopField)
                ;ToReturn .= A_Desktop "\" A_LoopField "`n"  
                num++
            }
        } else if (class ~= "(Cabinet|Explore)WClass") {  
            for window in ComObjCreate("Shell.Application").Windows 
			{
				try{
                if (window.hwnd==hwnd)  
                    sel := window.Document.SelectedItems  
				}catch e {
					continue
			}
			}
            for item in sel
            {
                ;ToReturn .= item.path item.name item.type "`n" 
                if item.IsFolder
                {
                    upFold:=True
                }
                else if item.IsLink
                {
                    upLink:=True
                }
                else
                {
                    UpFile(item.path,item.name)
                    num++
                }
            }
            if upFold
                MsgBox,��֧���ϴ��ļ���
            else if upLink
                MsgBox,��֧���ϴ���ݷ�ʽ
            MsgBox,���ϴ�%num%���ļ�
        }  
    ;return Trim(ToReturn,"`n")  
}

UpFile(path,name){
    c :=adbc " push """ path """ ""sdcard/Download/" name """ & " adbc " shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d ""file:///storage/emulated/0/Download/" name """"
    MsgBox,%c%
    MsgBox % RunWaitOne(c)
}

CheckAdb(){
    c :=adbc " connect 127.0.0.1:58526"
    d :=RunWaitOne(c)
    IfInString,d,connected
    {
        ;MsgBox % 
        Explorer_GetSelection(hwnd)
    }
    else
        MsgBox, %d%
}

RunWaitOne(command) {
    ; WshShell ����: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; ͨ�� cmd.exe ִ�е�������
    exec := shell.Exec(ComSpec " /C " command)
    ; ��ȡ��������������
    return exec.StdOut.ReadAll()
}

RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    ; �� cmd.exe ����������ʾ
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; ���Ͳ�ִ������,ʹ�����зָ�
    exec.StdIn.WriteLine(commands "`nexit")  ; ��ִ֤����Ϻ��˳�!
    ; ��ȡ������������������
    return exec.StdOut.ReadAll()
}