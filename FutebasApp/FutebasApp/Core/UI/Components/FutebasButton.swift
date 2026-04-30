//
//  FutebasButton.swift
//  FutebasApp
//
//  Created by Rodrigo Garcia on 28/04/26.
// e uma classe reutilizavel para criacao de botoes, a ideia é deixar no formato pronto para o uso.

import UIKit

final class FutebasButton: UIButton {
    
    // Enum responsavel pelos tipos de botes (Normal, secundario ou destrutivo)
    enum Style {
        case primary
        case secondary
        case danger
    }
    
    init(title: String, style: Style = .primary) {
        super.init(frame: .zero)
        setup(title: title, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func setup(title: String, style: Style, ) {
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        switch style {
        case .primary:
            backgroundColor = .systemGreen
            setTitleColor(.white, for: .normal)
            
        case .secondary:
            backgroundColor = FutebasColors.primary
            setTitleColor( FutebasColors.textPrimary, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGreen.cgColor
            
        case .danger:
            backgroundColor = UIColor.systemRed
            setTitleColor(.white, for: .normal)
        }
        
    }
    
}
