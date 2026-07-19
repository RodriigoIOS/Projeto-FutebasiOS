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
    
    
    var loginTextField = FutebasTextField(placeholder: "name@example.com", icon: UIImage(systemName: "envelope.fill"))
    
    
    var passwordTextField: FutebasTextField = {
        let textField = FutebasTextField(placeholder: "********", icon: UIImage(systemName: "lock.fill"))
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//    var passwordTextField: UITextField = {
//        let textField = UITextField(frame: .zero)
//        textField.layer.borderWidth = 0.5
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "Insira sua senha"
//        return textField
//    }()
    
    var loginButton: FutebasButton = {
        let button = FutebasButton(title: "Login", style: .secondary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(LoginViewController.self, action: #selector (actionLoginBtn), for: .touchUpInside)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
    }
    
    @objc private func actionLoginBtn() {
        print("The button was pressed")
    }
    
    func addSubviews() {
        view.addSubview(loginLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
    }
    
    func addConstraints() {
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            loginLabel.widthAnchor.constraint(equalToConstant: 50),
            loginLabel.heightAnchor.constraint(equalToConstant: 50),
            
            loginTextField.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: 12),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 15),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            passwordLabel.widthAnchor.constraint(equalToConstant: 50),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            loginButton.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 100)
            
            
        ])
    }
}

import SwiftUI

#Preview {
    LoginViewControllerPreview {
        LoginViewController()
    }
}
