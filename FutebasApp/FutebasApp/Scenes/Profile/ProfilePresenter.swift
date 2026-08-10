//
//  ProfilePresenter.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

protocol ProfilePresentationLogic {
    func presentProfile(_ response: Profile.Load.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {

    weak var viewController: ProfileDisplayLogic?

    func presentProfile(_ response: Profile.Load.Response) {
        // Hoje é um passthrough (Response e ViewModel são iguais). É aqui que
        // entraria formatação de exibição no futuro — ex: capitalizar nome,
        // ordenar seções por prioridade — sem o Interactor saber disso.
        viewController?.displayProfile(Profile.Load.ViewModel(sections: response.sections))
    }
}
