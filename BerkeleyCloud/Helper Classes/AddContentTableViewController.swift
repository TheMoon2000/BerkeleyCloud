//
//  AddContentTableViewController.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/12.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class AddContentTableViewController: UITableViewController, UITextFieldDelegate {

    var localDirectoryController: LocalDirectory!
    var currentDirectory: String! // Should not be modified
    /// Whether the new content will be a file, a folder, or a symbolic link.
    var contentType: FileType = .File
    private var contentNameField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = "New Item"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createContent))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissView))
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.isUserInteractionEnabled = true
    
    }
    
    @objc func dismissView() {
        if let visible = localDirectoryController.tableView.indexPathsForVisibleRows {
            localDirectoryController.tableView.reloadRows(at: visible, with: .automatic)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func createContent() {
        if let contentName = contentNameField?.text {
            if contentName == "" {
                let alert = UIAlertController(title: "Invalid Name",
                                              message: "You have entered a blank name for the new \(contentType.rawValue.lowercased()), which is invalid.",
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title: "Understood", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
                
            if contentName.contains(":") {
                let alert = UIAlertController(title: "Invalid Name",
                                              message: "Please make sure that your \(contentType.rawValue.lowercased()) name does not contain special characters.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Understood", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // relative path
            let newPath = localDirectoryController.absoluteURL.appendingPathComponent(contentName)
            do {
                switch contentType {
                case .File:
                    try "".write(to: newPath, atomically: false, encoding: .utf8)
                    print("Successfully added file to path: \(newPath).")
                case .Folder:
                    try FileManager.default.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
                    print("Successfully created folder at path: \(newPath).")
                case .Link: // file or folder doesn't matter here
                    let destination = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! EditableTextCell
                    print("Created symbolic link at: ", destination.textField.text!, "local destination: \(destination.textField.text ?? "(null)")")
                    try FileManager.default.createSymbolicLink(atPath: newPath.path, withDestinationPath: destination.textField.text ?? "")
                case .FileAlias:
                    break
                }
            } catch let error {
                print(error)
            }
            localDirectoryController?.tableView.reloadData()
            localDirectoryController?.tableView.endEditing(false)
            dismissView() // temporary placeholder
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Name", "Type"][section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = EditableTextCell()
            cell.setup()
            cell.textField.delegate = self
            self.contentNameField = cell.textField
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "nil")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Content Type"
            cell.detailTextLabel?.text = contentType.rawValue
            return cell
        case (1, 1):
            if contentType == .Link {
                let cell = EditableTextCell()
                cell.setup()
                cell.textField.text = currentDirectory + "/"
                cell.textField.placeholder = "Destination (relative path)"
                return cell
            } else {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "nil")
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = "group_name"
                cell.textLabel?.text = "Ownership"
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    // Delegate method for the content name table cell
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section, indexPath.row) == (1, 0) {
            let contentTypeTableViewController = ContentTypeTableViewController()
            contentTypeTableViewController.parentTable = self
            let index = [.File, .Folder, .Link].firstIndex(of: contentType) ?? 0
            contentTypeTableViewController.selectedIndex = index
            self.navigationController?.pushViewController(contentTypeTableViewController, animated: true)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
 
    

}
