//
//  MatchDetailWorker.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Combine

final class MatchDetailWorker {
    private let store = MatchesStore.shared

    func publisher(matchId: String) -> AnyPublisher<Match?, Never> {
        store.publisher
            .map { matches in matches.first { $0.id == matchId } }
            .eraseToAnyPublisher()
    }

    func toggleTimer(matchId: String) {
        store.toggleTimer(id: matchId)
    }

    func toggleFixedGK(matchId: String) {
        store.toggleFixedGK(matchId: matchId)
    }

    func addTeam(matchId: String) {
        store.addTeam(matchId: matchId)
    }

    func removeTeam(matchId: String, teamId: String) {
        store.removeTeam(matchId: matchId, teamId: teamId)
    }

    func addPlayer(matchId: String, teamId: String) {
        store.addPlayer(matchId: matchId, teamId: teamId)
    }

    func removePlayer(matchId: String, teamId: String, index: Int) {
        store.removePlayer(matchId: matchId, teamId: teamId, index: index)
    }
}
