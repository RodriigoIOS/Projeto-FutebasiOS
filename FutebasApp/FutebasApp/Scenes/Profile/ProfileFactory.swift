//
//  ProfileFactory.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Monta a cadeia VIP da cena (View -> Interactor -> Presenter) e devolve a
/// ViewController pronta para o Coordinator navegar até ela. A cena e o
/// Coordinator não sabem *como* essa montagem acontece — só o Factory sabe.
enum ProfileFactory {
    static func make() -> ProfileViewController {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
