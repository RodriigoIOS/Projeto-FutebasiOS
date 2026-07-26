//
//  MatchDetailPresenter.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

protocol MatchDetailPresentationLogic {
    func presentMatch(_ response: MatchDetail.Fetch.Response)
}

final class MatchDetailPresenter: MatchDetailPresentationLogic {

    weak var viewController: MatchDetailDisplayLogic?

    func presentMatch(_ response: MatchDetail.Fetch.Response) {
        guard let match = response.match else {
            viewController?.displayNotFound()
            return
        }

        let maxPlayers = match.hasFixedGK ? 6 : 5
        let teams = match.teams.map { team -> MatchDetail.TeamViewModel in
            let players = team.players.enumerated().map { index, name in
                MatchDetail.PlayerViewModel(index: index, name: name, initials: String(name.prefix(2)).uppercased())
            }
            return MatchDetail.TeamViewModel(
                id: team.id,
                name: team.name,
                color: team.color,
                players: players,
                canAddPlayer: team.players.count < maxPlayers
            )
        }

        let viewModel = MatchDetail.Fetch.ViewModel(
            title: match.title,
            location: match.location,
            displayDate: MatchFormatting.date(match.date),
            displayTimer: MatchFormatting.timer(match.remainingSeconds),
            isRunning: match.isRunning,
            hasFixedGK: match.hasFixedGK,
            teams: teams,
            canAddTeam: match.teams.count < 4
        )
        viewController?.displayMatch(viewModel)
    }
}
