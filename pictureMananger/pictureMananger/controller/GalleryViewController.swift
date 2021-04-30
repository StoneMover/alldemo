//
//  GalleryViewController.swift
//  pictureMananger
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class GalleryViewController: NSViewController {
    
    var dataArray : Array<FileModel>!

    var selectIndex : Int = 0
    
    @IBOutlet weak var contentImgView: NSImageView!
    
    @IBOutlet weak var lastBtn: NSButton!
    
    @IBOutlet weak var nextBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func loadData() -> Void {
        self.view.window?.title = self.dataArray[selectIndex].name!
        self.contentImgView.image = nil
        let image = NSImage.init(contentsOf: URL.init(fileURLWithPath: self.dataArray[self.selectIndex].url!))
        self.contentImgView.image = image
        self.lastBtn.isEnabled = self.selectIndex != 0
        self.nextBtn.isEnabled = self.selectIndex != self.dataArray.count - 1
        
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        self.contentImgView.frame = self.view.bounds
    }
    
    @IBAction func lastClick(_ sender: Any) {
        if selectIndex == 0 {
            return
        }
        self.selectIndex -= 1
        loadData()
    }
    
    @IBAction func nextClick(_ sender: Any) {
        if selectIndex == self.dataArray.count - 1 {
            return
        }
        self.selectIndex += 1
        loadData()
    }
}
