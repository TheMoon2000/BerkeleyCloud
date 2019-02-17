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
    
    var contentType: FileType = .File {
        didSet {
            switch contentType {
            case .File:
                iconImage.image = #imageLiteral(resourceName: "file")
                self.accessoryType = .detailButton
            case .Folder:
                iconImage.image = #imageLiteral(resourceName: "folder")
                self.accessoryType = .detailDisclosureButton
            case .Link:
                iconImage.image = #imageLiteral(resourceName: "symlink_folder")
                self.accessoryType = .detailDisclosureButton
            case .FileAlias:
                iconImage.image = #imageLiteral(resourceName: "symlink_file")
                self.accessoryType = .detailButton
            }
        }
    }
    
    // Editing and selections
    
    /// Whether the current cell is displayed in edit mode (with check)
    var editMode = false {
        didSet {
            selectionSign?.isHidden = !editMode
            contentLeftSpacing.constant = editMode ? 48 : 18
            self.layoutIfNeeded()
            self.selectionStyle = editMode ? .none : .default
        }
    }
    
    /// Alter the selection status of the cell.
    func toggleEditMode() {
//        UIView.animate(withDuration: 0.25) {
            self.editMode = !self.editMode
//        }
    }
    
    var selectionSign: UIView!
    
    private var contentLeftSpacing: NSLayoutConstraint!


    private var iconImage: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private var fileNameLabel: UILabel?
    var tableView: UITableView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        Swift.print("cell setup")
        self.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }
    
    func cellSetup() {
        insertIconImage()
        insertFileNameLabel()
        insertSelectionSign()
    }
    
    private func insertIconImage() {
        self.addSubview(iconImage)
        
        iconImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        contentLeftSpacing = iconImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        contentLeftSpacing.isActive = true
    }
    
    private func insertFileNameLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Placeholder text"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        fileNameLabel = label
        self.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func insertSelectionSign() {
        let sign = UIView()
        sign.isHidden = !editMode
        sign.translatesAutoresizingMaskIntoConstraints = false
        
        selectionSign = sign
        self.addSubview(sign)
        
        sign.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        sign.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sign.widthAnchor.constraint(equalToConstant: 15).isActive = true
        sign.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        sign.layer.cornerRadius = 7.5
        sign.layer.borderColor = UIColor(white: 0.93, alpha: 1).cgColor
        sign.layer.borderWidth = 1
        sign.backgroundColor = isSelected ? .blue : .clear
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionSign.backgroundColor = selected ? selectionBubbleColor : .clear
        
    }

}
