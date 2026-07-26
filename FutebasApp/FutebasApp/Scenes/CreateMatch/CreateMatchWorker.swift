//
//  CreateMatchWorker.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

final class CreateMatchWorker {
    private let store = MatchesStore.shared

    func save(_ match: Match) {
        store.add(match)
    }
}
