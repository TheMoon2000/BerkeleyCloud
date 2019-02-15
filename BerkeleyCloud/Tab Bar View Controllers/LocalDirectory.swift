//
//  LocalDirectory.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class LocalDirectory: UITableViewController {
    
    var localDirectoryViewController: LocalDirectoryViewController?
    
    /// The current directory for the local directory view.
    
    var currentPath: String {
        get {
            return localDirectoryViewController!.currentDirectory
        }
        set {
            localDirectoryViewController?.currentDirectory
        }
    }
    
    /// Returns the root path of the current directory in the filesystem.
    var absoluteURL: URL {
        return URL(fileURLWithPath: currentPath, relativeTo: DOCUMENTS)
    }
    
    /// Returns the content list of the current directory, nil if cannot.
    var currentContents: [URL]? {
        do {
            return try FileManager.default.contentsOfDirectory(at: absoluteURL, includingPropertiesForKeys: DIRECTORY_KEYS, options: .skipsSubdirectoryDescendants)
        } catch {
            print("Unable to retrieve directory: \(absoluteURL.absoluteString)")
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tableView.separatorInset.left = 0
        print("Absolute URL: ", absoluteURL)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let files = currentContents {
            localDirectoryViewController?.prompt?.isHidden = files.count > 0
            return files.count
        } else {
            localDirectoryViewController?.prompt?.text = "Unable to access directory"
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemURL = currentContents![indexPath.row]
        print(itemURL)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FileCell()
        cell.indentationLevel = 2
        cell.cellSetup()
        cell.tableView = tableView
        cell.fileName = currentContents![indexPath.item].lastPathComponent
        
        // Detailed information about the content item
        do {
        let keys = try currentContents![indexPath.item].resourceValues(forKeys: Set(DIRECTORY_KEYS))
            if keys.isDirectory! {
                cell.contentType = .Folder
            } else if keys.isAliasFile! {
                let des = try FileManager.default.destinationOfSymbolicLink(atPath: keys.path!)
                let aliasFullURL = URL(fileURLWithPath: des, relativeTo: DOCUMENTS)
                do {
                    try FileManager.default.contentsOfDirectory(atPath: aliasFullURL.path)
                    cell.contentType = .Link
                } catch let error {
                    cell.contentType = .FileAlias
                }
            } else {
                cell.contentType = .File
            }
        } catch let error {
            print(error)
        }

        return cell
    }
    /*
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            print("is editing")
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFile))
            localDirectoryViewController?.navigationItem.setLeftBarButton(addButton, animated: true)
//            navigationItem.hidesBackButton = true
        } else {
            print("done editing")
            localDirectoryViewController?.navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        }
    }*/
    
    @objc func editTable(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            sender.title = "Done"
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFile))
            localDirectoryViewController?.navigationItem.setLeftBarButton(addButton, animated: true)
        } else {
            sender.title = "Edit"
            localDirectoryViewController?.navigationItem.leftBarButtonItem = nil
        }
    }
    
    
    // Bring up the new content view to add file, folder or symbolic link
    @objc private func addFile() {
        let addContentVC = AddContentTableViewController()
        addContentVC.localDirectoryController = self
        addContentVC.currentDirectory = currentPath
        let addFileView = UINavigationController(rootViewController: addContentVC)
        localDirectoryViewController?.present(addFileView, animated: true) {
            print("completed")
        }
    }
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, index) in
            let cell = tableView.cellForRow(at: index) as! FileCell
            do {
                let absolutePathOfFile = self.absoluteURL.appendingPathComponent(cell.fileName)
                try FileManager.default.removeItem(at: absolutePathOfFile)
                print("Deleted file at \(absolutePathOfFile.path)")
            } catch let error {
                print("unable to remove file")
                print(error)
            }
            tableView.deleteRows(at: [index], with: .fade)
        }
        return [delete]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
