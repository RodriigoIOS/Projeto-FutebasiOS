//
//  Spacing.swift
//  FutebasApp
//
//  Created by Rodrigo Garcia on 27/04/26.
//

import Foundation
import UIKit

final class FutebasTextField: UITextField {
    
    private let padding: UIEdgeInsets
    private let iconImageView = UIImageView()
    
    init(
        placeholder: String,
        icon: UIImage? = nil,
        padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 18)
    ) {
        self.padding = padding
        super.init(frame: .zero)
        
        setupUI(placeholder: placeholder, icon: icon )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Metodo referente a configuracao da UITextField
    private func setupUI(placeholder: String, icon: UIImage?) {
        self.placeholder = placeholder
        self.backgroundColor = UIColor.systemGray6
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.font = .systemFont(ofSize: 16, weight: .regular)
        self.textColor = .label
        self.tintColor = .systemGreen
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        if let icon {
            setupLeftIcon(icon)
        }
    }
    
    // Metodo responsavel pelo icone na esquerda
    private func setupLeftIcon(_ icon: UIImage) {
        iconImageView.image = icon
        iconImageView.tintColor = .systemGreen
        iconImageView.contentMode = .scaleAspectFit
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 24))
        iconImageView.frame = CGRect(x: 5, y: 2, width: 20, height: 20)
        
        container.addSubview(iconImageView)
        leftView = container
        leftViewMode = .always
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
