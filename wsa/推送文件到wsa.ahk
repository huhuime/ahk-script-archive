;设置adb路径，如果设置好环境变量直接用变量
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
                MsgBox,不支持上传文件夹
            else if upLink
                MsgBox,不支持上传快捷方式
            MsgBox,已上传%num%个文件
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
    ; WshShell 对象: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; 通过 cmd.exe 执行单条命令
    exec := shell.Exec(ComSpec " /C " command)
    ; 读取并返回命令的输出
    return exec.StdOut.ReadAll()
}

RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    ; 打开 cmd.exe 禁用命令显示
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; 发送并执行命令,使用新行分隔
    exec.StdIn.WriteLine(commands "`nexit")  ; 保证执行完毕后退出!
    ; 读取并返回所有命令的输出
    return exec.StdOut.ReadAll()
}