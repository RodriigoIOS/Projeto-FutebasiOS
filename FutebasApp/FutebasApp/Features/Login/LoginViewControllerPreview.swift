//
//  UIViewControllerSwiftUI.swift
//  FutebasApp
//
//  Created by Rodrigo Garcia on 30/04/26.
//

import UIKit
import SwiftUI

struct LoginViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let ViewControllerBuilder: () -> ViewController
    
    init(_ viewControllerBuilder: @escaping() -> ViewController) {
        self.ViewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        ViewControllerBuilder()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // A atualizar codigo
    }
}
