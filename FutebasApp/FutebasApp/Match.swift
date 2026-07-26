//
//  Match.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

struct Match: Identifiable {
    let id: String
    var title: String
    var location: String
    var date: Date
    var remainingSeconds: Int
    var isRunning: Bool
    var hasFixedGK: Bool
    var teams: [Team]

    static let duration = 480

    var isEnded: Bool { remainingSeconds <= 0 }
}

struct Team: Identifiable {
    let id: String
    var name: String
    var color: UIColor
    var players: [String]

    // Ordem e cores fixas usadas ao sortear um novo time, igual ao protótipo.
    static let palette: [(name: String, color: UIColor)] = [
        ("Time Verde", FutebasColors.primary),
        ("Time Preto", FutebasColors.textPrimary),
        ("Time Laranja", FutebasColors.warning),
        ("Time Vermelho", FutebasColors.danger),
    ]
}
