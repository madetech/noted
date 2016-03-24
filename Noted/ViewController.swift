//
//  ViewController.swift
//  Noted
//
//  Created by David Winter on 24/03/2016.
//  Copyright © 2016 Made Tech. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var fileNames: [String]!
    @IBOutlet var fileNameTableView: NSTableView!
    @IBOutlet var fileContentsView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        fileNameTableView.setDelegate(self)
        fileNameTableView.setDataSource(self)
    }
    
    func loadNotes() {
        print("Loading notes from " + directoryPath())
        let fs: NSFileManager = NSFileManager()
        let files = fs.enumeratorAtPath(directoryPath())
        fileNames = files?.filter(isTextFile).map({(file) -> String in String(file)})
    }

    
    func isTextFile(file: AnyObject) -> Bool {
        return file.pathExtension == "txt"
    }
    
    func directoryPath() -> String {
        return NSHomeDirectory() + "/Dropbox/Notes/"
    }
    
    func filePath(fileName: String) -> String {
        return directoryPath() + fileName
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return fileNames.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        cell.textField?.stringValue = fileNames[row]
        return cell;
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let fileContents = tryFileContents(filePath(fileNames[fileNameTableView.selectedRow]))
        
        fileContentsView.string = fileContents
    }
    
    func tryFileContents(filePath: String) -> String {
        do {
            let fileString = try String(contentsOfFile: filePath)
            return fileString
        } catch {
            return "No contents found"
        }
    }

}

