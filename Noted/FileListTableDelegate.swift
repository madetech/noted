//
//  FileListTableDelegate.swift
//  Noted
//
//  Created by David Winter on 24/03/2016.
//  Copyright © 2016 Made Tech. All rights reserved.
//

import Cocoa

class FileListTableDelegate: NSObject, NSTableViewDelegate {
    var fileNames: [String]!
    
    init (fileNamesArray: [String]) {
        self.fileNames = fileNamesArray
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        cell.textField?.stringValue = fileNames[row]
        return cell;
    }
}
