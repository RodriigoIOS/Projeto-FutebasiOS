//
//  CreateMatchPresenter.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

protocol CreateMatchPresentationLogic {
    func presentFormState(_ response: CreateMatch.FormChanged.Response)
    func presentSaved()
}

final class CreateMatchPresenter: CreateMatchPresentationLogic {

    weak var viewController: CreateMatchDisplayLogic?

    func presentFormState(_ response: CreateMatch.FormChanged.Response) {
        viewController?.displayFormState(CreateMatch.FormChanged.ViewModel(isSaveEnabled: response.isSaveEnabled))
    }

    func presentSaved() {
        viewController?.displaySaved()
    }
}
