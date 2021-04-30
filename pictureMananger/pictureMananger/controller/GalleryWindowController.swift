//
//  GalleryWindowController.swift
//  pictureMananger
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class GalleryWindowController: NSWindowController,NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window?.title = "图片管理";
        initWindowDefaultSize()
        self.window?.delegate = self
    }
    
    private func initWindowDefaultSize(){
        let height = NSScreen.main!.frame.size.height / 3 * 2
        let width =  height
        self.window!.setContentSize(.init(width: width, height: height))
        self.window!.setFrameOrigin(NSPoint.init(x: (NSScreen.main!.frame.size.width - width)/2, y: (NSScreen.main!.frame.size.height - height)/2))
        
        self.window!.maxSize = .init(width: NSScreen.main!.frame.size.height / 4 * 3, height: NSScreen.main!.frame.size.height / 4 * 3)
        self.window!.contentMaxSize = self.window!.maxSize
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }
    
    func windowShouldZoom(_ window: NSWindow, toFrame newFrame: NSRect) -> Bool {
        return false
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        
        return frameSize
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return self.contentViewController?.title ?? ""
    }

}
