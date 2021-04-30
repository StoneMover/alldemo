//
//  AppDelegate.swift
//  pictureMananger
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    //当点击关闭按钮重新打开的时候
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApplication.shared.windows[0].makeKeyAndOrderFront(self)
        return true
    }

    //导入根目录
    @IBAction func importFolder(_ sender: Any) {
        let panel = NSOpenPanel.init()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin {[weak panel] (result) in
            if result == .OK{
                let path = panel?.urls.first?.path
                if path == nil{
                    return
                }
                
                AppHelp.help.addFolder(path!)
            }
        }
    }
    
}

