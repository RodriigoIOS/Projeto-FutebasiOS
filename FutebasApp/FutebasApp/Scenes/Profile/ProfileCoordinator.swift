//
//  ProfileCoordinator.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Cena-folha: hoje sem sub-navegação (não empurra outras telas), só monta a
/// ProfileViewController via Factory e a coloca na raiz do seu próprio
/// UINavigationController. Fica no mesmo formato do MatchesCoordinator de
/// propósito — se um dia o perfil precisar navegar pra algum lugar (ex:
/// "editar foto", "histórico"), você adiciona um `func routeToX()` aqui sem
/// precisar mudar quem já usa este Coordinator (o HomeCoordinator).
final class ProfileCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = ProfileFactory.make()
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [viewController]
    }
}
