//
//  MatchesPresenter.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

protocol MatchesPresentationLogic {
    func presentMatches(_ response: Matches.Fetch.Response)
}

final class MatchesPresenter: MatchesPresentationLogic {

    weak var viewController: MatchesDisplayLogic?

    func presentMatches(_ response: Matches.Fetch.Response) {
        let cells = response.matches.map { match in
            Matches.Fetch.Cell(
                id: match.id,
                title: match.title,
                location: match.location,
                displayDate: MatchFormatting.date(match.date),
                displayTimer: MatchFormatting.timer(match.remainingSeconds),
                isRunning: match.isRunning,
                isEnded: match.isEnded
            )
        }
        viewController?.displayMatches(Matches.Fetch.ViewModel(isEmpty: cells.isEmpty, cells: cells))
    }
}
