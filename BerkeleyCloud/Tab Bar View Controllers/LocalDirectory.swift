//
//  LocalDirectory.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class LocalDirectory: UITableViewController {
    
    var prompt: UILabel!
    var isRoot = false
    
    /// The current directory for the local directory view.
    var currentPath = "."
    
    /// Returns the root path of the current directory in the filesystem.
    var absoluteURL: URL {
        return URL(fileURLWithPath: currentPath, relativeTo: DOCUMENTS)
    }
    
    /// Whether the table is in select / edit mode
    var editMode = false {
        didSet {
            for cell in tableView.visibleCells {
                (cell as? FileCell)?.toggleEditMode()
            }
            tableView.allowsMultipleSelection = editMode
            selectedRows.removeAll()
        }
    }
    
    /// Returns the content list of the current directory, nil if cannot.
    var currentContents: [URL]? {
        do {
            return try FileManager.default.contentsOfDirectory(at: absoluteURL, includingPropertiesForKeys: DIRECTORY_KEYS, options: .skipsSubdirectoryDescendants).sorted(by: { (first, second) -> Bool in
                first.lastPathComponent < second.lastPathComponent
            })
        } catch {
            print("Unable to retrieve directory: \(absoluteURL.absoluteString)")
        }
        return nil
    }
    
    /// An int array containing the selected rows
    var selectedRows = Set<Int>() {
        didSet {
            navigationItem.title = editMode ? "\(selectedRows.count) Item(s) Selected" : absoluteURL.lastPathComponent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // So that unused cells don't appear out of nowhere
        tableView.tableFooterView = UIView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tableView.separatorInset.left = 0
        view.backgroundColor = mediumGray
        
        print("Absolute URL: ", absoluteURL)
        
        navigationItem.title = absoluteURL.lastPathComponent
        
        loadPlaceholderText()
        setupNavigationBar()
    }
    
    private func loadPlaceholderText() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(white: 0, alpha: 0.9)
        titleLabel.textAlignment = .center
        titleLabel.center = view.center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        prompt = titleLabel
        view.addSubview(titleLabel)
        
        // Constraints
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editTable(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = barTint
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let files = currentContents {
            self.prompt?.isHidden = files.count > 0
            self.prompt?.text = files.count > 0 ? "" : "No files to show."
            return files.count
        } else {
            self.prompt?.text = "Unable to access directory"
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemURL = currentContents![indexPath.row]
        if editMode {
            if selectedRows.contains(indexPath.row) {
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                selectedRows.insert(indexPath.row)
            }
            print("new selection: \(selectedRows)")
        } else {
            print(itemURL) // This is the absolute url
            let localPath = NSString(string: currentPath).appendingPathComponent(itemURL.lastPathComponent)
            do {
                let resourceKeys = try itemURL.resourceValues(forKeys: Set(DIRECTORY_KEYS))
                if resourceKeys.isAliasFile! {
                    let des = try FileManager.default.destinationOfSymbolicLink(atPath: resourceKeys.path!)
                    let aliasFullURL = URL(fileURLWithPath: des, relativeTo: DOCUMENTS)
                    do {
                        try FileManager.default.contentsOfDirectory(atPath: aliasFullURL.path)
                        pushToNewDirectory(path: des)
                    } catch {
                        print("Original file at \(des).")
                    }
                } else if resourceKeys.isDirectory! {
                    pushToNewDirectory(path: localPath)
                } else {
                    // opens the file
                    print("opens the file '\(itemURL.lastPathComponent)'")
                }
            } catch {
                print("Error occurredd while processing \(localPath), needs debugging.")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func pushToNewDirectory(path: String) {
        let newDirectory = LocalDirectory()
//        newDirectory.hidesBottomBarWhenPushed = true
        newDirectory.currentPath = path
        self.navigationController?.pushViewController(newDirectory, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.remove(indexPath.row)
        print("remaining rows: \(selectedRows)")
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FileCell()
        cell.indentationLevel = 2
        cell.cellSetup()
        cell.editMode = self.editMode
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
                } catch {
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
        if !editMode {
            editMode = true
            sender.title = "Done"
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFile))
            self.navigationItem.setLeftBarButton(addButton, animated: true)
        } else {
            editMode = false
            sender.title = "Edit"
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    
    // Bring up the new content view to add file, folder or symbolic link
    @objc private func addFile() {
        let addContentVC = AddContentTableViewController()
        addContentVC.localDirectoryController = self
        addContentVC.currentDirectory = currentPath
        let addFileView = UINavigationController(rootViewController: addContentVC)
        self.present(addFileView, animated: true) {
            print("completed")
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
        let cell = tableView.cellForRow(at: indexPath) as! FileCell
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, handler) in
            let alert = UIAlertController(title: "Delete '\(cell.fileName)'?", message: "This action cannot be undone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                do {
                    let absolutePathOfFile = self.absoluteURL.appendingPathComponent(cell.fileName)
                    try FileManager.default.removeItem(at: absolutePathOfFile)
                    handler(true)
                    tableView.deleteRows(at: [tableView.indexPath(for: cell)!], with: .automatic)
                    print("Deleted file at \(absolutePathOfFile.path)")
                } catch let error {
                    print("unable to remove file")
                    print(error)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) in
                handler(false)
            }))
            self.present(alert, animated: true, completion: nil)
        }

        let more = UIContextualAction(style: .normal, title: "More") { (action, sourceView, handler) in
            let alert = UIAlertController(title: "Select File Operation", message: "What would you like to do with this item?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action) in
                // renames file
                handler(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                handler(true)
            }))
            self.present(alert, animated: true, completion: {})
        }
        more.backgroundColor = moreOptions

        let act = UISwipeActionsConfiguration(actions: [delete, more])
        act.performsFirstActionWithFullSwipe = false
    
        return act
    }
    
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        return nil
//    }

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
