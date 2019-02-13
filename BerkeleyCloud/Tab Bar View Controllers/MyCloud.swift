//
//  MyCloudViewController.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class MyCloudViewController: UIViewController {
    
    var titleLabel: UILabel?
    var setupCloudButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Cloud"
        
        addTitleText()
        addLoginButton()
    }
    
    private func addTitleText() {
        let titleLabel = UILabel()//(frame: CGRect(x: 0, y: 0, width: 300, height: 65))
        titleLabel.text = "You are not logged in."
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        titleLabel.center = view.center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func addLoginButton() {
        let button = UIButton(type: .system)
        button.layer.borderColor = buttonBorder.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 23
        button.tintColor = UIColor(cgColor: button.layer.borderColor!)
        for i in [UIControl.State.normal, .selected, .highlighted, .disabled, .focused] {
            button.setTitle("Set Up Cloud", for: i)
        }
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        setupCloudButton = button
        
        // Constraints
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let belowLabel = button.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 25)
        let height = button.heightAnchor.constraint(equalToConstant: 45)
        let width = button.widthAnchor.constraint(equalToConstant: 170)
        view.addConstraints([centerX, belowLabel, width, height])
        
        button.addTarget(self, action: #selector(self.setupCloud(_:)), for: .touchUpInside)
    }
    
    @objc private func setupCloud(_ sender: UIButton) {
        if sender == setupCloudButton {
            let alert = UIAlertController(title: "This Alert Does Nothing", message: "The set up view is supposed to show up.", preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: {print("done")})
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
