//
//  LoginViewController.swift
//  FutebasApp
//
//  Created by Rodrigo on 17/02/26.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "System", size: 12)
        return label
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Senha"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "System", size: 12)
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        addSubviews()
        addConstraints()
    }
    
    @objc func actionLoginBtn() {
        
    }
    
    func addSubviews() {
        
    }
    
    func addConstraints() {
        
    }
}
