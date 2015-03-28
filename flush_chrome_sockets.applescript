#!/usr/bin/osascript

--this script is to resolve the problem that Chrome can't use the correct hosts after modifying hosts file  because of  Chrome using socket pools.
--This script just simulates the click event on the button of "Flush socket pool"  on chrome://net-internals/#sockets page.
tell application "Google Chrome"
	tell front window
		
		--record current active tab and its index.
		set origTab to active tab
		set origTabIndex to active tab index
		
		--open Chrome sockets page.
		set theTab to make new tab with properties {URL:"chrome://net-internals/#sockets"}
		
		--waiting for loading html document
		set isLoadDone to not loading of theTab
		repeat until isLoadDone
			set isLoadDone to not loading of theTab
		end repeat
		
		
		--Chrome has to spend some time to execute init javascript,or the javascript statements in the below execute commond won't work.
		--How long you should delay depends on the performance of your mac.
		delay 1
		
		--flush Chrome sockets
		--you can find below javascript statements in Chrome's net-internal index.js on line 9860 and 9861
		execute theTab javascript "g_browser.sendFlushSocketPools();g_browser.checkForUpdatedInfo(false);"
		
		--close Chrome sockets page
		close theTab
		
		--reactive the previous tab
		set active tab index to origTabIndex
		
		--reload the previous tab
		reload origTab
		
	end tell
end tell


