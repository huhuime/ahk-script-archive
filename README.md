# AHK脚本存档

#### 介绍

暂存

#### 软件架构

AutoHotKey脚本

#### 安装教程

1. 安装[AutoHotKey](https://www.autohotkey.com/)
2. 运行ank脚本

#### 使用说明

1. 运行ank脚本或者直接下载exe文件直接运行

#### 简易ahk脚本通过adb上传文件到wsa中使用说明

##### 使用

 **必须在wsa已运行应用情况下** （不管是前台还是后台）

在资源管理器中选中文件按快捷键`win+z`触发上传

##### 安装
 **下载adb并设置环境变量** （此处自行搜索教程，太多了，此处不在重复）

方案一（使用ahk文件）：

1. 安装[AutoHotKey](https://www.autohotkey.com/)
1. 下载文件[推送文件到wsa.ahk](https://gitee.com/huhuhuhu/ahk-script-archive/raw/master/wsa/%E6%8E%A8%E9%80%81%E6%96%87%E4%BB%B6%E5%88%B0wsa.ahk)
1. 双击该ahk运行，如需开机自启请移动到启动文件夹（`%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`）


方案二（使用exe文件，无需安装AutoHotKey，但文件不能修改）：

1. 下载文件[推送文件到wsa.exe](https://gitee.com/huhuhuhu/ahk-script-archive/releases/%E7%AE%80%E6%98%93ahk%E8%84%9A%E6%9C%AC%E9%80%9A%E8%BF%87adb%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6%E5%88%B0wsa%E4%B8%AD)
1. 双击该exe运行，如需开机自启请移动到启动文件夹（`%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`）


以上安装方案任选其一


##### 其他事项
如不想设置adb环境变量，可修改ahk脚本第2行内容`global adbc :="adb"`自行指定位置（暂未测试）
已知问题：
1. adb无法连接时报错内容乱码
2. 暂未支持文件夹直接上传
3. 暂无法隐藏命令行窗口
