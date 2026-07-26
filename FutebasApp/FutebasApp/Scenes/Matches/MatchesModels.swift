//
//  MatchesModels.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

enum Matches {

    enum Fetch {
        struct Request {}

        struct Response {
            let matches: [Match]
        }

        struct ViewModel {
            let isEmpty: Bool
            let cells: [Cell]
        }

        struct Cell {
            let id: String
            let title: String
            let location: String
            let displayDate: String
            let displayTimer: String
            let isRunning: Bool
            let isEnded: Bool
        }
    }

    enum ToggleTimer {
        struct Request {
            let id: String
        }
    }

    enum DeleteMatch {
        struct Request {
            let id: String
        }
    }
}
