//
//  LocalDirectoryViewController.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class LocalDirectoryViewController: UIViewController {
    
    var tableController: LocalDirectory!
    var prompt: UILabel?
    
    /// The local path of the directory browser.
    var currentDirectory = "."
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Local Directory"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mediumGray
        
        loadPlaceholderText() // 1. Add the text field in the background
        loadTable() // 2. Add a table view to the screen
        setupNavigationBar() // 3. Add toolbar buttons
        
    }
    
    private func loadPlaceholderText() {
        let titleLabel = UILabel()
        titleLabel.text = "No files to show."
        titleLabel.isHidden = true
        titleLabel.textColor = UIColor(white: 0, alpha: 0.9)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        prompt = titleLabel
        view.addSubview(titleLabel)
        
        // Constraints
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func loadTable() {
        let tableController = LocalDirectory()
        tableController.localDirectoryViewController = self
        
        let t = tableController.tableView! // For simplicity
        
        t.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(t)
        t.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        t.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        t.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        t.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.tableController = tableController
    }
    
    private func setupNavigationBar() {
        if let tc = tableController {
            let editButton = UIBarButtonItem(title: "Edit",
                                             style: .plain,
                                             target: tc,
                                             action: #selector(tc.editTable(_:)))
            self.navigationItem.rightBarButtonItem = editButton
        }
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
