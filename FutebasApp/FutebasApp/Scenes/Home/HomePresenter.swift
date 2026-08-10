//
//  HomePresenter.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

protocol HomePresentationLogic {
    func presentHome(_ response: Home.Load.Response)
}

final class HomePresenter: HomePresentationLogic {

    weak var viewController: HomeDisplayLogic?

    func presentHome(_ response: Home.Load.Response) {
        let viewModel = Home.Load.ViewModel(initialTabIndex: response.initialTabIndex)
        viewController?.displayHome(viewModel)
    }
}
