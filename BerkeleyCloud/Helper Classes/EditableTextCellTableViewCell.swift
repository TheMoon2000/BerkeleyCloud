//
//  EditableTextCell.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/13.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class EditableTextCell: UITableViewCell, UITextFieldDelegate {
    
    var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Name"
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        return field
    }()
    
    func setup() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.selectionStyle = .none
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
