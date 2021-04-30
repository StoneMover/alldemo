//
//  FileModel.swift
//  pictureMananger
//
//  Created by apple on 2020/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa


class FileModel: BTModel {
    
    var name : String?
    
    //folder:0,file:1
    var type : Int = 0
    
    var url : String?
    
    var isSelect = false
    
    var img : NSImage?
    
}
