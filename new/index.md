# ahk脚本：通过adb上传文件或截图到wsa中

**已重写，改为调用Powershell且已测试在终端预览版中运行无问题，托盘右键菜单增加调试模式**

---

### 使用说明

1. 运行ank脚本或者直接下载exe文件直接运行
2. 按 `win+z` 触发

#### 上传文件

1. 在资源管理器中选中文件
2. 按 `win+z` 触发

#### 上传截图

1. 截图（推荐 `win+shfit+s` 使用系统截图）
2. 按 `win+z` 触发

### 安装说明

 **下载adb并设置环境变量** （此处自行搜索教程，太多了，此处不在重复）

方案一（使用ahk文件）：

1. 安装[AutoHotKey](https://www.autohotkey.com/)
2. 下载文件[推送文件到wsa.ahk](https://gitee.com/huhuhuhu/ahk-script-archive/raw/master/new/%E6%8E%A8%E9%80%81%E6%96%87%E4%BB%B6%E5%88%B0wsa.ahk)
3. 双击该ahk运行，如需开机自启请移动或创建快捷方式到启动文件夹（`%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`）


方案二（使用exe文件，无需安装AutoHotKey，但文件不能修改）：

1. 下载文件[推送文件到wsa.exe](https://gitee.com/huhuhuhu/ahk-script-archive/releases/ahk%E8%84%9A%E6%9C%AC%E9%80%9A%E8%BF%87adb%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6%E6%88%96%E6%88%AA%E5%9B%BE%E5%88%B0wsa%E4%B8%AD)
2. 双击该exe运行，如需开机自启请移动或创建快捷方式到启动文件夹（`%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`）


 **以上安装方案任选其一** 

### 预览效果

![上传截图](https://images.gitee.com/uploads/images/2021/1101/124310_21f65d59_73755.gif "GIF1.gif")
![上传文件](https://images.gitee.com/uploads/images/2021/1101/124336_6924f3be_73755.gif "GIF2.gif")

### 其他事项

如不想设置adb环境变量，可修改ahk脚本第2行内容`global adbc :="adb"`自行指定位置（暂未测试）

#### 已知问题

1. 上传截图会先在脚本文件夹内生成 `tmp.png` 临时图片
2. 仍未支持文件夹直接上传
3. 发出的通知不能保证每条都弹出（不知道是不是win11的bug）
4. 暂无法获取 `adb push *>&1` 进度信息，目前使用伪进度条实现，可通过修改ahk脚本第4行内容`global step :=30`自行指定速度

备注（代码参照）：
- https://docs.microsoft.com/zh-cn/powershell/?view=powershell
- https://blog.csdn.net/liuyukuan/article/details/53399286
