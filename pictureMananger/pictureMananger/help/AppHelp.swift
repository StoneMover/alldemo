//
//  AppHelp.swift
//  pictureMananger
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa
import Foundation

class AppHelp: NSObject {

    public static let help = AppHelp.init()
    
    var folderPathArray : Array<String>!
    
    override init() {
        super.init()
        folderPathArray = UserDefaults.standard.array(forKey: "PICTURE_MANANGER") as? Array<String> ?? [String]()
        print("")
    }
    
    public func addFolder(_ url : String){
        if folderPathArray.contains(url) {
            
            return
        }
        folderPathArray.append(url)
        UserDefaults.standard.setValue(folderPathArray, forKey: "PICTURE_MANANGER")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(Notification.init(name: Notification.Name("UPDATE_FOLDER")))
    }
    
    public func delFolder(_ url : String){
        folderPathArray.remove(at: folderPathArray.firstIndex(of: url)!)
        UserDefaults.standard.setValue(folderPathArray, forKey: "PICTURE_MANANGER")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(Notification.init(name: Notification.Name("DELETE_FOLDER")))
    }
    
    public func delFolder(_ index : Int){
        folderPathArray.remove(at: index)
        UserDefaults.standard.setValue(folderPathArray, forKey: "PICTURE_MANANGER")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(Notification.init(name: Notification.Name("DELETE_FOLDER")))
    }
    
}
