# launchctl

## 1. 介绍

`launchd` 类似 Linux上的`systemd`, 它是系统启动后第一个创建的进程,其他进程都是它的子进程.利用`launchctl` 可以管理`launchd` ,创建监控/定时/自启任务.

`launchd`的配置文件以`plist`结尾,格式是xml,根据不同的存放路径对应不同的类型:

| 类型           | 路径                            | 说明                                         |
| -------------- | :------------------------------ | :------------------------------------------- |
| User Agents    | `~/Library/LaunchAgents`        | 用户 Agents. 当前用户登录时运行(推荐)        |
| Global Agents  | `/Library/LaunchAgents`         | 全局 Agents. 任何用户登录时都会运行          |
| System Agents  | `/System/Library/LaunchAgents`  | 系统 Agents. 任何用户登录时都会运行          |
| Global Daemons | `/Library/LaunchDaemons`        | 全局 Daemons. 内核初始化加载完后就运行(推荐) |
| System Daemons | `/System/Library/LaunchDaemons` | 系统 Daemons. 内核初始化加载完后就运行       |

## 2. 使用

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
    <!--Label是必填项,与文件名对应-->
		<key>Label</key>
		<string>simpread.sync</string>
    <!--是否自动重启-->
		<key>KeepAlive</key>
		<true/>
    <!--是否加载后立刻启动-->
		<key>RunAtLoad</key>
		<true/>
    <!--执行参数,第一行为可执行文件,其余为参数-->
		<key>ProgramArguments</key>
		<array>
			<string>/Users/tedmosby/sw/simpread-sync_darwin_amd64/simpread-sync</string>
      <string>-c</string>
      <!--每个参数必须在单独的string块里-->
      <string>/Users/tedmosby/sw/simpread-sync_darwin_amd64/config.json</string>
		</array>
    <!--错误日志输出文件-->
    <key>StandardErrorPath</key>
    <!--一般日志输出文件-->
		<string>/Users/tedmosby/sw/simpread-sync_darwin_amd64/log</string>
    <key>StandardOutPath</key>
		<string>/Users/tedmosby/sw/simpread-sync_darwin_amd64/log</string>
    <!--自动任务:特定时间执行-->
    <key>StartCalendarInterval</key>
    <dict>
      <key>Minute</key>
      <integer>30</integer>
      <key>Hour</key>
      <integer>9</integer>
      <key>Day</key>
      <integer>1</integer>
      <key>Month</key>
      <integer>5</integer>
      <!-- 0和7都指星期天 -->
      <key>Weekday</key>
      <integer>0</integer>
    </dict>
    <!--自动任务:特定间隔执行-->
    <key>StartInterval</key>
    <integer>3600</integer>
    <!--自动任务:监控目录变化后执行-->
    <key>WatchPaths</key>
    <array>
      <string>/Library/Preferences/SystemConfiguration</string>
    </array>
	</dict>
</plist>

```

## 3. 命令

```bash
#添加任务
launchctl load simpread.sync.plist
#移除任务
launchctl unload simpread.sync.plist
#查看任务 0:执行 78:异常
launchctl list
#检测plist
plutil simpread.sync.plist
#杀掉进程并重启
launchctl kickstart -k simpread.sync.plist
```

