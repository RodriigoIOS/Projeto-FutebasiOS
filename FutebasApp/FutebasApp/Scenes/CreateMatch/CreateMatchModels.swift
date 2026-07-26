//
//  CreateMatchModels.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

enum CreateMatch {

    enum FormChanged {
        struct Request {
            let title: String
            let location: String
            let date: String
            let time: String
        }

        struct Response {
            let isSaveEnabled: Bool
        }

        struct ViewModel {
            let isSaveEnabled: Bool
        }
    }

    enum Save {
        struct Request {
            let title: String
            let location: String
            let date: String
            let time: String
        }
    }
}
