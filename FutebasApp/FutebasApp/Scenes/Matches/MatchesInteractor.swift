//
//  MatchesInteractor.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Combine

protocol MatchesBusinessLogic {
    func fetchMatches(_ request: Matches.Fetch.Request)
    func toggleTimer(_ request: Matches.ToggleTimer.Request)
    func deleteMatch(_ request: Matches.DeleteMatch.Request)
}

final class MatchesInteractor: MatchesBusinessLogic {

    var presenter: MatchesPresentationLogic?
    var worker = MatchesWorker()

    private var cancellable: AnyCancellable?

    func fetchMatches(_ request: Matches.Fetch.Request) {
        guard cancellable == nil else { return }
        cancellable = worker.publisher.sink { [weak self] matches in
            self?.presenter?.presentMatches(Matches.Fetch.Response(matches: matches))
        }
    }

    func toggleTimer(_ request: Matches.ToggleTimer.Request) {
        worker.toggleTimer(id: request.id)
    }

    func deleteMatch(_ request: Matches.DeleteMatch.Request) {
        worker.deleteMatch(id: request.id)
    }
}
