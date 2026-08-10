//
//  ProfileModels.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

enum Profile {

    /// Um campo editável do perfil. A ideia central desta tela: modelar cada
    /// campo como *dado* (em vez de cada um virar uma view fixa/hard-coded no
    /// storyboard ou no código) é o que permite adicionar um campo novo sem
    /// tocar em layout — você só adiciona um `Field` na lista que o Interactor
    /// monta, e a View desenha ele sozinha.
    struct Field {
        /// Como o campo deve ser editado. Adicionar um novo tipo de edição no
        /// futuro (ex: data, foto) é adicionar um case aqui + tratar ele em
        /// `ProfileFieldRowView.configure(with:)`.
        enum Kind {
            case text                  // texto livre: Nome, Idade, Time do coração
            case options([String])     // escolha fixa: Sexo, Pé dominante
        }

        let id: String
        let title: String
        let placeholder: String
        let kind: Kind
        var value: String
    }

    /// Um grupo de campos exibido como um "card" na tela — mesmo conceito dos
    /// boxes com borda da referência que você mandou ("O que melhoramos" etc).
    /// Para adicionar uma seção nova: crie outro `Section(title:fields:)` no
    /// array do `ProfileInteractor`. Nenhum arquivo de View precisa mudar.
    struct Section {
        let title: String
        var fields: [Field]
    }

    enum Load {
        struct Request {}

        struct Response {
            let sections: [Section]
        }

        struct ViewModel {
            let sections: [Section]
        }
    }

    enum UpdateField {
        struct Request {
            let id: String
            let newValue: String
        }
    }
}
