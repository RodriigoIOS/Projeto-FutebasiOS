//
//  ProfileInteractor.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

protocol ProfileBusinessLogic {
    func loadProfile(_ request: Profile.Load.Request)
    func updateField(_ request: Profile.UpdateField.Request)
}

final class ProfileInteractor: ProfileBusinessLogic {

    var presenter: ProfilePresentationLogic?

    // MVP: estado em memória, começa como fonte da verdade. Quando integrar
    // com Firestore isso vira um ProfileWorker (mesmo papel do MatchesWorker):
    // `loadProfile` passa a buscar do banco e `updateField` a salvar nele,
    // sem que Presenter/View precisem mudar uma linha.
    private var sections: [Profile.Section] = [
        Profile.Section(
            title: "Dados pessoais",
            fields: [
                Profile.Field(id: "name", title: "Nome", placeholder: "Seu nome", kind: .text, value: ""),
                Profile.Field(id: "age", title: "Idade", placeholder: "Sua idade", kind: .text, value: ""),
                Profile.Field(id: "gender", title: "Sexo", placeholder: "", kind: .options(["Masculino", "Feminino", "Outro"]), value: ""),
                Profile.Field(id: "dominantFoot", title: "Pé dominante", placeholder: "", kind: .options(["Esquerdo", "Direito"]), value: ""),
                Profile.Field(id: "favoriteTeam", title: "Time do coração", placeholder: "Ex: Flamengo", kind: .text, value: ""),
            ]
        ),
        Profile.Section(
            title: "Preferências de jogo",
            fields: [
                Profile.Field(id: "Position", title: "Posição", placeholder: "Ex: Atacante", kind: .text, value: ""),
                Profile.Field(id: "test", title: "Teste", placeholder: "another test", kind: .text, value: "")
            ]
        ),
        // Para adicionar uma seção nova (ex: "Preferências de jogo"), copie o
        // bloco acima com outro título e outra lista de `Field`s. A
        // ProfileView cria um card novo automaticamente a partir deste array.
    ]

    func loadProfile(_ request: Profile.Load.Request) {
        presenter?.presentProfile(Profile.Load.Response(sections: sections))
    }

    func updateField(_ request: Profile.UpdateField.Request) {
        for sectionIndex in sections.indices {
            guard let fieldIndex = sections[sectionIndex].fields.firstIndex(where: { $0.id == request.id }) else {
                continue
            }
            sections[sectionIndex].fields[fieldIndex].value = request.newValue
            break
        }
        // Sem Response/Presenter aqui de propósito: quem já mostra o valor
        // digitado é o próprio UITextField/UISegmentedControl na tela — o
        // Interactor só precisa guardar o estado (e, no futuro, persistir).
    }
}
