//
//  HomeFolderCell.swift
//  pictureMananger
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class HomeFolderCell: NSTableCellView {

    
    
    @IBOutlet weak var nameLabel: NSTextField!
    
    @IBOutlet weak var lineView: NSView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        lineView.wantsLayer = true
        lineView.layer?.backgroundColor = NSColor.lightGray.cgColor
        // Drawing code here.
    }
    
}
