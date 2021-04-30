//
//  HomeWindowController.swift
//  pictureMananger
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class HomeWindowController: NSWindowController,NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = "图片管理";
        initWindowDefaultSize()
        self.window?.delegate = self
    }
    
    private func initWindowDefaultSize(){
        let width =  NSScreen.main!.frame.size.width / 3 * 2
        let height = NSScreen.main!.frame.size.height / 3 * 2
        self.window?.setContentSize(.init(width: width, height: height))
        self.window?.setFrameOrigin(NSPoint.init(x: (NSScreen.main!.frame.size.width - width)/2, y: (NSScreen.main!.frame.size.height - height)/2))
    }

    //MARK:NSWindowDelegate
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }
    
    func windowWillClose(_ notification: Notification) {
        
    }
    
}
