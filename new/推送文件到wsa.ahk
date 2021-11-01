;设置adb路径，如果设置好环境变量直接用变量
global adbc :="adb"
;暂时无法获取adb push  *>&1 进度条,此处模拟进度条速度
global step :=30
global debug :=false


Menu, tray, add  ; 创建分隔线.
Menu, tray, add, 调试模式, MenuHandler  ; 创建新菜单项.

#z::
    Explorer_GetSelection()
return


MenuHandler:
    Menu, Tray, ToggleCheck, 调试模式
    debug :=!debug
return

goShell(cm){
    if(debug){
         c :="&{" cm ";;Write-Warning '调试模式下关闭本窗口才能再次执行'}"
        MsgBox,%c%
        RunWait, PowerShell -noexit -Command %c%
        return
    }
    c :="&{try {" cm  "}catch{if((New-Object -ComObject WScript.Shell).Popup($_.ScriptStackTrace+$_,0,'发生错误,如需反馈请截图后点击确定跳转反馈页面',1+16)){explorer https://gitee.com/huhuhuhu/ahk-script-archive/issues}}exit;}"
    RunWait, PowerShell -Command %c% ,, Hide
}
sendClip(){
    c :=strProgressTost() strChaeckadb("Add-Type -AssemblyName System.Windows.Forms;if ($([System.Windows.Forms.Clipboard]`:`:ContainsImage())) {$image = [System.Windows.Forms.Clipboard]`:`:GetImage();$filename='tmp.png';[System.Drawing.Bitmap]$image.Save($filename, [System.Drawing.Imaging.ImageFormat]`:`:Png);New-ProgressTost '剪贴板图片' '0' '0/1' '上传中...';$n='clip.'+(Get-Date -UFormat `%s)+'.png';Push-file '.\tmp.png' $n;New-Tost '推送剪贴板图片至WSA完成' $n ($kaa+$wja);}else{New-Tost '剪贴板中无图片' '请尝试选中文件或截图' $jta;}")
    goShell(c)
}

Explorer_GetSelection(hwnd="")   
{  
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")  
    WinGetClass class, ahk_id %hwnd%  
    if (process != "explorer.exe") {
        sendClip()
        return  
    }
    ToReturn :=""
    ToInfo :=""
    num :=0
    if (class ~= "Progman|WorkerW") {  
        ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%  
        Loop, Parse, files, `n, `r  
        {
            ;UpFile( A_Desktop "\" A_LoopField,A_LoopField)
            ;ToReturn .= A_Desktop "\" A_LoopField "`n"  
            ToReturn .=UpFile( A_Desktop "\" A_LoopField,A_LoopField,num++)
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
            if (item.IsFolder && !(item.name ~=".zip$"))
            {
                upFold:=True
            }
            else if item.IsLink
            {
                upLink:=True
            }
            else
            {
                ;UpFile(item.path,item.name)
                ToReturn .=UpFile(item.path,item.name,num++)
            }
        }
        if upFold
            ToInfo .="New-Tost '不支持推送文件夹' '请尝试选中文件或截图' $jta;"
        else if upLink
            ToInfo .="New-Tost '不支持推送快捷方式' '请尝试选中文件或截图' $jta;"
        else if (num = 0){
            sendClip()
            return 
        }
        ;MsgBox,已上传%num%个文件
    } else{
        
    }
    c :=strProgressTost() strProgress() strChaeckadb(ToInfo "$num=" num ";$step=" (1/num/step) ";New-ProgressTost '等待推送' 0 '0/" num "' '准备中...';" ToReturn "clear-toast;New-Tost '推送至wsa完成' '已推送" num "个文件' ($kaa+$wja+$fka);")
    goShell(c)
}
UpFile(path,name,n){
    return "$v=(" n "/$num);Update-Toast '" name "' $v ('" n "/'+$num) '上传中...';$job=Update-Progress $v;Push-file '" path "' '" name "';Receive-Job -job $job;Stop-Job -job $job;Update-Toast '" name "' (" (n+1) "/$num) ('" (n+1) "/'+$num) '上传中...';"
}
strProgress(){
    return "Function Update-Progress{Param([Parameter(Mandatory,Position = 0)][String]$Value);Write-Host $step;Write-Host ($value+$step);$job=Start-Job -ScriptBlock {Function Update-Toast{$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.ToastData, ContentType = WindowsRuntime];$list =new-object 'System.Collections.Generic.List[system.collections.generic.KeyValuePair[string,string]]';$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Value',$Value);$list.Add($tmp);$ToastData = [Windows.UI.Notifications.NotificationData]`:`:new( $list);[Windows.UI.Notifications.ToastNotificationManager]`:`:CreateToastNotifier($AppId).Update( $ToastData,$tag,$group);};$AppId=$args[0];$tag=$args[1];$group=$args[2];$value=([float]$args[3]);$step=([float]$args[4]);for($i=1;$i -lt " step ";$i++){Start-Sleep -m 300;$value+=$step;Update-Toast;}} -ArgumentList $AppId,$tag,$group,$Value,$step;return $job;}"
}
strBase(){
    return "$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe';$tag = 'push';$group = 'adb';$kaa='<action activationType=""""""Protocol"""""" arguments=""""""wsa://com.coolapk.market"""""" content=""""""跳转酷安""""""/>';$kfa='<action activationType=""""""Protocol"""""" arguments=""""""wsa-client://developer-settings"""""" content=""""""跳转开发者选项""""""/>';$wja='<action activationType=""""""Protocol"""""" arguments=""""""wsa://com.android.documentsui"""""" content=""""""跳转文件""""""/>';$jta='<action activationType=""""""Protocol"""""" arguments=""""""ms-screenclip:?delayInSeconds=1"""""" content=""""""截图""""""/>';$fka='<action activationType=""""""Protocol"""""" arguments=""""""https://gitee.com/huhuhuhu/ahk-script-archive/issues"""""" content=""""""使用反馈""""""/>';Function New-Tost{[cmdletBinding()]Param([Parameter(Mandatory, Position = 0)][String]$Title,[Parameter(Mandatory,Position = 1)][String]$Message,[Parameter(Position = 2)][String]$Actions = '');$XmlString ='<toast><visual><binding template=""""""ToastGeneric""""""><text>'+ $Title +'</text><text>'+ $Message +'</text></binding></visual><actions>'+ $Actions +'</actions></toast>';$XmlString;$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]; $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime];$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]`:`:new();$ToastXml.LoadXml($XmlString);$Toast = [Windows.UI.Notifications.ToastNotification]`:`:new($ToastXml);$Toast.Tag=$tag;$Toast.Group=$group;$Toast.SuppressPopup=$false;[Windows.UI.Notifications.ToastNotificationManager]`:`:CreateToastNotifier($AppId).Show($Toast);}function Push-file {param ([Parameter(Mandatory, Position = 0)][String]$Path,[Parameter(Mandatory,Position = 1)][String]$Name);" adbc " push ""$Path"" ""sdcard/Download/$Name"";" adbc " shell ""am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file:///storage/emulated/0/Download/$Name'""}function clear-toast{$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.ToastData, ContentType = WindowsRuntime];[Windows.UI.Notifications.ToastNotificationManager]`:`:History.Remove($tag,$group,$AppId);}"
}
strChaeckadb(Command){
    return strBase() "New-Tost '连接WSA中...' '" adbc " connect 127.0.0.1:58526';$s=(" adbc " connect 127.0.0.1:58526);if ($s -like '*connected*'){" Command "}else{clear-toast;New-Tost '连接wsa失败' ([System.Text.Encoding]`:`:UTF8.GetString([System.Text.Encoding]`:`:Default.GetBytes($s))) ($kaa + $kfa);}"
}
strProgressTost(){
    return "Function New-ProgressTost{[cmdletBinding()]Param([Parameter(Mandatory, Position = 0)][String]$Title,[Parameter(Mandatory,Position = 1)][String]$Value,[Parameter(Mandatory,Position = 2)][String]$Message,[Parameter(Mandatory,Position = 3)][String]$Status);$XmlString='<toast><visual><binding template=""""""ToastGeneric""""""><text>上传文件至WSA</text><progress title=""""""{Title}"""""" value=""""""{Value}"""""" valueStringOverride=""""""{Message}"""""" status=""""""{Status}""""""/></binding></visual></toast>';$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime];$null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime];$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]`:`:new();$ToastXml.LoadXml($XmlString);$Toast = [Windows.UI.Notifications.ToastNotification]`:`:new($ToastXml);$Toast.Tag=$tag;$Toast.Group=$group;$Toast.SuppressPopup=$false;$list =new-object 'System.Collections.Generic.List[system.collections.generic.KeyValuePair[string,string]]';$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Title',$Title);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Value',$Value);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Message',$Message);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Status',$Status);$list.Add($tmp);$ToastData = [Windows.UI.Notifications.NotificationData]`:`:new( $list);$Toast.Data=$ToastData;[Windows.UI.Notifications.ToastNotificationManager]`:`:CreateToastNotifier($AppId).Show($Toast);}Function Update-Toast{[cmdletBinding()]Param([Parameter(Mandatory, Position = 0)][String]$Title,[Parameter(Mandatory,Position = 1)][String]$Value,[Parameter(Mandatory,Position = 2)][String]$Message,[Parameter(Mandatory,Position = 3)][String]$Status);$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.ToastData, ContentType = WindowsRuntime];$list =new-object 'System.Collections.Generic.List[system.collections.generic.KeyValuePair[string,string]]';$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Title',$Title);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Value',$Value);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Message',$Message);$list.Add($tmp);$tmp=new-object 'system.collections.generic.KeyValuePair[string,string]'('Status',$Status);$list.Add($tmp);$ToastData = [Windows.UI.Notifications.NotificationData]`:`:new( $list);[Windows.UI.Notifications.ToastNotificationManager]`:`:CreateToastNotifier($AppId).Update( $ToastData,$tag,$group);}"
}


;;