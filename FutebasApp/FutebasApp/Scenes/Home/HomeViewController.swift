//
//  HomeViewController.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayHome(_ viewModel: Home.Load.ViewModel)
}

final class HomeViewController: UIViewController {

    var interactor: HomeBusinessLogic?
    weak var coordinator: HomeCoordinator?

    private let homeView = HomeView()
    private var tabViewControllers: [UIViewController] = []

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // A HomeView decide sozinha (UITabBar nativa vs. FutebasCompatTabBar)
        // qual controle usar dependendo da versão do iOS — aqui só reagimos
        // ao toque, sem saber qual dos dois está por trás.
        homeView.onSelectTag = { [weak self] tag in
            self?.display(at: tag)
        }

        interactor?.loadHome(Home.Load.Request())
    }

    /// Injetado pelo Coordinator antes da tela aparecer: cada índice corresponde
    /// a um item da barra (na mesma ordem definida na HomeView).
    func setTabs(_ viewControllers: [UIViewController]) {
        tabViewControllers = viewControllers
    }

    private func display(at index: Int) {
        guard tabViewControllers.indices.contains(index) else { return }

        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        let viewController = tabViewControllers[index]
        addChild(viewController)
        viewController.view.frame = homeView.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        homeView.containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayHome(_ viewModel: Home.Load.ViewModel) {
        display(at: viewModel.initialTabIndex)
        homeView.selectTag(viewModel.initialTabIndex)
    }
}
