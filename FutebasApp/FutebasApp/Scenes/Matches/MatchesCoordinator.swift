//
//  MatchesCoordinator.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

final class MatchesCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MatchesViewController()
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [viewController]
    }

    func routeToCreateMatch() {
        let viewController = CreateMatchViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func routeToDetail(matchId: String) {
        let viewController = MatchDetailViewController(matchId: matchId)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
