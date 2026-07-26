//
//  MatchesWorker.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Combine

/// Casca fina sobre o MatchesStore. Quando a persistência migrar para
/// Firestore (SDD seção 6/7), só este arquivo precisa mudar.
final class MatchesWorker {
    private let store = MatchesStore.shared

    var publisher: AnyPublisher<[Match], Never> { store.publisher }

    func fetchMatches() -> [Match] {
        store.fetchMatches()
    }

    func toggleTimer(id: String) {
        store.toggleTimer(id: id)
    }

    func deleteMatch(id: String) {
        store.delete(id: id)
    }
}
