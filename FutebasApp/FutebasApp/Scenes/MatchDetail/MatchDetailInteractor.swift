//
//  MatchDetailInteractor.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Combine

protocol MatchDetailBusinessLogic {
    func fetchMatch(_ request: MatchDetail.Fetch.Request)
    func toggleTimer(_ request: MatchDetail.ToggleTimer.Request)
    func toggleFixedGK(_ request: MatchDetail.ToggleFixedGK.Request)
    func addTeam(_ request: MatchDetail.AddTeam.Request)
    func removeTeam(_ request: MatchDetail.RemoveTeam.Request)
    func addPlayer(_ request: MatchDetail.AddPlayer.Request)
    func removePlayer(_ request: MatchDetail.RemovePlayer.Request)
}

final class MatchDetailInteractor: MatchDetailBusinessLogic {

    var presenter: MatchDetailPresentationLogic?
    var worker = MatchDetailWorker()
    let matchId: String

    private var cancellable: AnyCancellable?

    init(matchId: String) {
        self.matchId = matchId
    }

    func fetchMatch(_ request: MatchDetail.Fetch.Request) {
        guard cancellable == nil else { return }
        cancellable = worker.publisher(matchId: matchId).sink { [weak self] match in
            self?.presenter?.presentMatch(MatchDetail.Fetch.Response(match: match))
        }
    }

    func toggleTimer(_ request: MatchDetail.ToggleTimer.Request) {
        worker.toggleTimer(matchId: matchId)
    }

    func toggleFixedGK(_ request: MatchDetail.ToggleFixedGK.Request) {
        worker.toggleFixedGK(matchId: matchId)
    }

    func addTeam(_ request: MatchDetail.AddTeam.Request) {
        worker.addTeam(matchId: matchId)
    }

    func removeTeam(_ request: MatchDetail.RemoveTeam.Request) {
        worker.removeTeam(matchId: matchId, teamId: request.teamId)
    }

    func addPlayer(_ request: MatchDetail.AddPlayer.Request) {
        worker.addPlayer(matchId: matchId, teamId: request.teamId)
    }

    func removePlayer(_ request: MatchDetail.RemovePlayer.Request) {
        worker.removePlayer(matchId: matchId, teamId: request.teamId, index: request.index)
    }
}
