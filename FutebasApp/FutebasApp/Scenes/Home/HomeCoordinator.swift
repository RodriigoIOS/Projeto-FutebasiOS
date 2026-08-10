//
//  HomeCoordinator.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

final class HomeCoordinator {

    private let navigationController: UINavigationController

    // Guardamos referência forte: se ninguém segurar esses Coordinators eles
    // seriam desalocados e a navegação interna de cada aba pararia de
    // funcionar mesmo com a tela ainda visível.
    private var matchesCoordinator: MatchesCoordinator?
    private var profileCoordinator: ProfileCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = HomeFactory.make()
        viewController.coordinator = self
        viewController.setTabs(makeTabs())

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [viewController]
    }

    // MARK: - Abas

    private func makeTabs() -> [UIViewController] {
        [
            makeMatchesTab(),
            makePlaceholderTab(title: "Em breve"),
            makeProfileTab(),
        ]
    }

    /// Primeira aba: o fluxo de Partidas já existente, com seu próprio
    /// Coordinator cuidando da navegação interna (criar partida, detalhe).
    private func makeMatchesTab() -> UIViewController {
        let matchesNavigationController = UINavigationController()
        let coordinator = MatchesCoordinator(navigationController: matchesNavigationController)
        coordinator.start()
        matchesCoordinator = coordinator
        return matchesNavigationController
    }

    /// Terceira aba: perfil do usuário, com seu próprio Coordinator (hoje
    /// simples, sem sub-navegação, mas já no formato certo pra crescer).
    private func makeProfileTab() -> UIViewController {
        let profileNavigationController = UINavigationController()
        let coordinator = ProfileCoordinator(navigationController: profileNavigationController)
        coordinator.start()
        profileCoordinator = coordinator
        return profileNavigationController
    }

    /// Placeholder simples para as abas que ainda não viraram cenas de verdade.
    /// Quando você implementar a próxima (Cronometro), troca esta chamada por
    /// `makeCronometroTab()` seguindo o mesmo padrão de `makeMatchesTab()`.
    private func makePlaceholderTab(title: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = FutebasColors.primary
        viewController.title = title
        return viewController
    }
}
