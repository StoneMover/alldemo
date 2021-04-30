//
//  HomeViewController.swift
//  pictureMananger
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 apple. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSMenuDelegate,NSCollectionViewDelegate,NSCollectionViewDataSource {
    
    

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var tableViewMenu = NSMenu(title: "删除")
    
    var collectionViewMenu = NSMenu(title: "删除")
    
    var urlArray = Array<String>.init()
    
    var dataArray = Array<FileModel>.init()
    
    var nowUrlIndex = 0
    
    @IBOutlet weak var backBtn: NSButton!
    
    @IBOutlet weak var forwordBtn: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(refresdData), name: NSNotification.Name("UPDATE_FOLDER"), object: nil)
        self.backBtn.isEnabled = false
        self.forwordBtn.isEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 67
        tableView.register(NSNib.init(nibNamed: NSNib.Name("HomeFolderCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeFolderCellId"))
        tableView.menu = tableViewMenu
        tableViewMenu.delegate = self
    }
    
    private func initCollectionView(){
        let nib = NSNib.init(nibNamed: NSNib.Name("HomeImgItem"), bundle: nil)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isSelectable = true
        self.collectionView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeImgItemId"))
        self.collectionView.menu = self.collectionViewMenu
        self.collectionViewMenu.delegate = self
        let layout = self.collectionView.collectionViewLayout as! NSCollectionViewFlowLayout
        layout.itemSize = .init(width: 120, height: 120)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
    }
    
    @objc func refresdData(){
        self.tableView.reloadData()
    }
    
    func refreshCollectionData(){
        
        if FileManager.default.isReadableFile(atPath: self.urlArray[nowUrlIndex]) == false {
            ProgressHUD.showErrorWithStatus("请打开文件读取权限")
            return
        }
        
        if self.nowUrlIndex == 0 {
            self.backBtn.isEnabled = false
        }else{
            self.backBtn.isEnabled = true
        }
        
        if self.nowUrlIndex == self.urlArray.count - 1 {
            self.forwordBtn.isEnabled = false
        }else{
            self.forwordBtn.isEnabled = true
        }
        
        self.dataArray.removeAll()
        var filePaths = [String]()
        
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: self.urlArray[nowUrlIndex])
            
            for fileName in array {
                var isDir: ObjCBool = true
                let fullPath = "\(self.urlArray[nowUrlIndex])/\(fileName)"
                
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    let model = FileModel.init()
                    model.url = fullPath
                    model.name = fullPath.components(separatedBy: "/").last!
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
//                        print("文件:"+fullPath)
                        if model.name!.hasSuffix("png") || model.name!.hasSuffix("jpg") || model.name!.hasSuffix("jpeg") {
                            model.type = 1
                            self.dataArray.append(model)
                        }
                    }else{
//                        print("文件夹:"+fullPath)
                        self.dataArray.append(model)
                    }
                }
                
                
            }
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        self.collectionView.reloadData()
    }
    
    //MARK:NSTableViewDelegate,NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return AppHelp.help.folderPathArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeFolderCellId"), owner: nil) as? HomeFolderCell
        cell?.nameLabel.stringValue = AppHelp.help.folderPathArray[row].components(separatedBy: "/").last ?? "名字错误"
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        self.nowUrlIndex = 0
        self.urlArray.removeAll()
        self.urlArray.append(AppHelp.help.folderPathArray[row])
        self.refreshCollectionData()
    }
    
    
    
    
    
    //MARK:NSMenuDelegate
    func menuNeedsUpdate(_ menu: NSMenu) {
        if menu == self.tableViewMenu {
            menu.removeAllItems()
            menu.addItem(NSMenuItem(title: "删除", action: #selector(deleteFolter(_:)), keyEquivalent: ""))
            return
        }
        
        if menu == self.collectionViewMenu {
            menu.removeAllItems()
            menu.addItem(NSMenuItem(title: "在finder中打开", action: #selector(openInFinder(item:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "删除", action: #selector(openInFinder(item:)), keyEquivalent: ""))
            return
        }
        
        
    }
    
    
    @objc func deleteFolter(_ item:NSMenuItem){
        let row = tableView.clickedRow
        AppHelp.help.delFolder(row)
        tableView.reloadData()
    }
    
    @objc func openInFinder(item : NSMenuItem){
        
    }
    
    //MARK:NSCollectionViewDelegate,NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeImgItemId"), for: indexPath) as! HomeImgItem
        let model = self.dataArray[indexPath.item]
        view.updateData(model, indexPath.item)
        view.doubleClick = {[weak self] () -> Void in
            self?.doubleClick(indexPath.item,model)
        }
        
        view.singleClick = {[weak self] () -> Void in
            self?.singleClick(indexPath.item)
        }
        return view
    }
    
    
    func singleClick(_ index : Int) -> Void {
        for m in self.dataArray {
            m.isSelect = false
        }
        
        self.dataArray[index].isSelect = true
        let items = self.collectionView.visibleItems()
        for item in items {
            let itemResult = item as! HomeImgItem
            itemResult.updateStatus()
        }
    }
    
    func doubleClick(_ index : Int,_ model : FileModel)->Void{
        let model = self.dataArray[index]
        if model.type == 0 {
            
            while self.urlArray[self.nowUrlIndex] != self.urlArray.last! {
                self.urlArray.removeLast()
            }
            
            self.urlArray.append(model.url!)
            self.nowUrlIndex += 1
            self.refreshCollectionData()
        }else{
            var dataShow = Array<FileModel>.init()
            for m in self.dataArray {
                if m.type == 1 {
                    dataShow.append(m)
                }
            }
            
            let windowVc = NSStoryboard.init(name: NSStoryboard.Name("Gallery"), bundle: nil).instantiateInitialController() as! GalleryWindowController
            let vc = windowVc.contentViewController as! GalleryViewController
            windowVc.showWindow(nil)
            vc.dataArray = dataShow
            vc.selectIndex = dataShow.firstIndex(of: model) ?? 0
            vc.loadData()
        }
    }
    
    @IBAction func backClick(_ sender: Any) {
        if self.nowUrlIndex == 0 {
            return
        }
        
        self.nowUrlIndex -= 1
        self.refreshCollectionData()
        
    }
    
    @IBAction func goClick(_ sender: Any) {
        if self.nowUrlIndex == self.urlArray.count - 1 {
            return
        }
        self.nowUrlIndex += 1
        self.refreshCollectionData()
    }
}
