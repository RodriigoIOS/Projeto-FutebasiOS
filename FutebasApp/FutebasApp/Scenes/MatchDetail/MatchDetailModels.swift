//
//  MatchDetailModels.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

enum MatchDetail {

    enum Fetch {
        struct Request {}

        struct Response {
            let match: Match?
        }

        struct ViewModel {
            let title: String
            let location: String
            let displayDate: String
            let displayTimer: String
            let isRunning: Bool
            let hasFixedGK: Bool
            let teams: [TeamViewModel]
            let canAddTeam: Bool
        }
    }

    struct TeamViewModel {
        let id: String
        let name: String
        let color: UIColor
        let players: [PlayerViewModel]
        let canAddPlayer: Bool
    }

    struct PlayerViewModel {
        let index: Int
        let name: String
        let initials: String
    }

    enum ToggleTimer {
        struct Request {}
    }

    enum ToggleFixedGK {
        struct Request {}
    }

    enum AddTeam {
        struct Request {}
    }

    enum RemoveTeam {
        struct Request {
            let teamId: String
        }
    }

    enum AddPlayer {
        struct Request {
            let teamId: String
        }
    }

    enum RemovePlayer {
        struct Request {
            let teamId: String
            let index: Int
        }
    }
}
