//
//  HomeImgItem.swift
//  pictureMananger
//
//  Created by apple on 2020/8/19.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class HomeImgItem: NSCollectionViewItem,NSMenuDelegate {

    @IBOutlet weak var contentImgView: NSImageView!
    
    @IBOutlet weak var nameLabel: NSTextField!
    
    @IBOutlet weak var viewBg: NSView!
    
    var model : FileModel?
    
    var index : Int = 0
    
    var doubleClick : (() ->Void)?
    
    var singleClick : (() ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置图片拉伸样式
        contentImgView.imageScaling = .scaleAxesIndependently
        
        //设置选中背景颜色
        let layer = CALayer.init()
        layer.frame = viewBg.bounds
        layer.backgroundColor = NSColor.white.cgColor
        self.viewBg.layer = layer
        layer.cornerRadius = 2
        
        
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if (event.pressure==1 && event.clickCount==2) {
            print("左键双击")
            doubleClick?()
        }
        
        if event.pressure == 1 && event.clickCount == 1 {
            print("左键单击")
            singleClick?()
        }
        
    }
    
//    override func rightMouseDown(with event: NSEvent) {
//        super.rightMouseUp(with: event)
//        print("右键点击")
//    }
    
    func updateData(_ model : FileModel,_ index : Int) -> Void {
        self.model = model
        self.index = index
        nameLabel.stringValue = model.name!
        if model.type == 0 {
            contentImgView.image = NSImage.init(named: NSImage.Name("NSFolder"))
            contentImgView.imageScaling = .scaleAxesIndependently
        }else{
            if model.img == nil {
                self.contentImgView.image = nil
                DispatchQueue.global().async {//并行、异步
                    let image = NSImage.init(contentsOf: URL.init(fileURLWithPath: model.url!))
                    if model.img == nil{
                        model.img = image
                    }
                    DispatchQueue.main.async {//串行、异步
                        self.contentImgView.image = image
                    }
                }
            }else{
                self.contentImgView.image = model.img
            }
            
            contentImgView.imageScaling = .scaleProportionallyDown
        }
        updateStatus()
        
    }
    
    func updateStatus() -> Void {
        if self.model?.isSelect == true {
            self.viewBg.layer?.backgroundColor = NSColor.lightGray.cgColor
        }else{
            self.viewBg.layer?.backgroundColor = NSColor.white.cgColor
        }
    }
    
    
}
