//
//  BTBaseView.swift
//  pictureMananger
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class BTBaseView: NSView {
    
    var doubleClick : (() ->Void)?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
    }
    
}
