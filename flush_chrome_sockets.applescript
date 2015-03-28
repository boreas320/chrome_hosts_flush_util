#!/usr/bin/osascript
--此脚本是为了处理每次切换hosts时Chrome总不能及时刷新正确的hosts的问题
tell application "Google Chrome"
	tell front window
		
		--记录初始tab及其索引位置
		set origTab to active tab
		set origTabIndex to active tab index
		
		--打开Chrome刷新sockets的页面
		set theTab to make new tab with properties {URL:"chrome://net-internals/#sockets"}
		
		--等待页面载入完毕,此处应该只是html文档载入完毕
		set isLoadDone to not loading of theTab
		repeat until isLoadDone
			set isLoadDone to not loading of theTab
		end repeat
		
		--需要为页面中的初始化javascript留出一段时间,此时间可以根据机器载入初始化javascript的时间进行适当的调整
		delay 1
		
		--执行刷新sockets连接的操作
		execute theTab javascript "g_browser.sendFlushSocketPools();g_browser.checkForUpdatedInfo(false);"
		
		--关闭Chrome刷新sockets的页面
		close theTab
		
		--跳回原来的工作tab页
		set active tab index to origTabIndex
		
		--重新载入工作tab页
		reload origTab
		
	end tell
end tell


