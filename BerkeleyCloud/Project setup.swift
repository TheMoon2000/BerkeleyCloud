//
//  Constants.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

let mediumGray = UIColor(red: 141/255, green: 148/255, blue: 171/255, alpha: 1)
let darkGray = UIColor(red: 99/255, green: 107/255, blue: 130/255, alpha: 1)
let buttonBorder = UIColor(red: 160/255, green: 170/255, blue: 200/255, alpha: 1)
let passphrase = "Berkeley Cloud" // Secret!


// This extension makes encryptions easier to handle
extension String {
    func encrypted(key: String) -> String {
        return NSString(string: self).aes256Encrypt(withKey: key)
    }
    
    func decrypted(key: String) -> String {
        return NSString(string: self).aes256Decrypt(withKey: key)
    }
}
