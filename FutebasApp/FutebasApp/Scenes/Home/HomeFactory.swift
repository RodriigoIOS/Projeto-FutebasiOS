//
//  HomeFactory.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Monta a cadeia VIP da cena (View -> Interactor -> Presenter) e devolve a
/// ViewController pronta para o Coordinator navegar até ela. A cena e o
/// Coordinator não sabem *como* essa montagem acontece — só o Factory sabe.
enum HomeFactory {
    static func make() -> HomeViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
