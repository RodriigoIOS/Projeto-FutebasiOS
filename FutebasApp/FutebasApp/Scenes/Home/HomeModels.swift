//
//  HomeModels.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import Foundation

enum Home {

    enum Load {
        struct Request {}

        struct Response {
            let initialTabIndex: Int
        }

        struct ViewModel {
            let initialTabIndex: Int
        }
    }
}
