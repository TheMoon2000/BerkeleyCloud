//
//  FileCell.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/12.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    
    var fileName: String = "_" {
        didSet {
//            textLabel?.text = fileName
            if (fileNameLabel != nil) {
                fileNameLabel?.text = fileName
            } else {
                Swift.print("nil!")
            }
        }
    }
    
    private var fileNameLabel: UILabel? {
        didSet {
            Swift.print("set file label")
        }
    }
    var tableView: UITableView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }
    
    func insertFileNameLabel() {
        Swift.print("initialize label")
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Placeholder text"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        fileNameLabel = label
        self.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
