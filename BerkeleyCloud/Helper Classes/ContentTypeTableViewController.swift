//
//  ContentTypeTableViewController.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/13.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class ContentTypeTableViewController: UITableViewController {
    
    var parentTable: AddContentTableViewController?
    var selectedIndex = 0 {
        didSet {
            parentTable?.contentType = [.File, .Folder, .Link][selectedIndex]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.title = "Content Type"
//        navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        
//        if let navi = parentTable?.navigationItem {
//            navi.leftBarButtonItem = navi.backBarButtonItem
//        }
        
        self.tableView = UITableView(frame: .zero, style: .grouped)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = [FileType.File.rawValue,
                                FileType.Folder.rawValue,
                                FileType.Link.rawValue][indexPath.row]
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        if selectedIndex != indexPath.row {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
            selectedIndex = indexPath.row
            parentTable?.contentType = [FileType.File, .Folder, .Link][selectedIndex]
            parentTable?.tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)], with: .automatic)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
