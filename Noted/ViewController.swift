//
//  ViewController.swift
//  Noted
//
//  Created by David Winter on 24/03/2016.
//  Copyright © 2016 Made Tech. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate {
    
    var fileNames: [String]!
    @IBOutlet var fileNameTableView: NSTableView!
    @IBOutlet var fileContentsView: NSTextView!
    @IBOutlet var queryFieldView: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        fileNameTableView.setDelegate(self)
        fileNameTableView.setDataSource(self)
        fileContentsView.delegate = self
    }
    
    func loadNotes(query: String = "") {
        print(query)
        print("Loading notes from " + directoryPath())
        let fs: NSFileManager = NSFileManager()
        let files = fs.enumeratorAtPath(directoryPath())
        fileNames = files?.filter(isTextFile)
                          .filter(queryFn(query))
                          .map({(file) -> String in String(file)})
    }
    
    func queryFn(query: String) -> (AnyObject) -> Bool {
        return {(file: AnyObject) -> Bool in
            if query == "" {
                return true
            } else {
                return String(file).rangeOfString(query) != nil
            }
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        if theEvent.keyCode == 53 {
            queryFieldView.becomeFirstResponder()
        }
    }
    
    @IBAction func newFile(sender: AnyObject) {
        let saveDialog = NSSavePanel()
        saveDialog.runModal()
        let newFilePath = saveDialog.URL?.path
        let myNewFileContents = ""
        do {
            try myNewFileContents.writeToFile(newFilePath!, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print("can't save")
        }
        
        loadNotes()
        fileNameTableView.reloadData()
    }
    
    @IBAction func searchFiles(sender: NSTextField) {
        print("Search files")
        loadNotes(sender.stringValue)
        fileNameTableView.reloadData()
    }
    
    @IBAction func saveFile(sender: AnyObject) {
        do {
            try fileContentsView.string!.writeToFile(selectedFilePath(), atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print("Failed to save")
        }
        
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
        let fileContents = tryFileContents(selectedFilePath())
        
        fileContentsView.string = fileContents
    }
    
    func selectedFilePath() -> String {
        return filePath(fileNames[fileNameTableView.selectedRow])
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

