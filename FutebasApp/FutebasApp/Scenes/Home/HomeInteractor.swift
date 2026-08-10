//
//  HomeInteractor.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

protocol HomeBusinessLogic {
    func loadHome(_ request: Home.Load.Request)
}

final class HomeInteractor: HomeBusinessLogic {

    var presenter: HomePresentationLogic?

    func loadHome(_ request: Home.Load.Request) {
        // Regra de negócio é trivial hoje (sempre abre em "Partidas"), mas mora aqui
        // e não na ViewController porque é aqui que ela vai crescer: por exemplo,
        // decidir abrir direto na aba de convite pendente. Trocar o child view
        // controller visível, por outro lado, é estado de UI puro e fica na View/VC.
        let response = Home.Load.Response(initialTabIndex: 0)
        presenter?.presentHome(response)
    }
}
