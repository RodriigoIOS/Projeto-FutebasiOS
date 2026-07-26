//
//  MatchesStore.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation
import Combine

/// Repositório em memória compartilhado por todas as cenas.
/// Os métodos espelham o formato que os Workers usarão quando a persistência
/// migrar para Firestore (ver SDD seção 6/7), então a troca futura fica isolada aqui.
final class MatchesStore {

    static let shared = MatchesStore()

    private var matches: [Match]
    private let subject: CurrentValueSubject<[Match], Never>
    var publisher: AnyPublisher<[Match], Never> { subject.eraseToAnyPublisher() }

    // Timer único que atualiza todas as partidas em andamento a cada tick,
    // em vez de um Timer por partida (recomendação do SDD seção 7.3).
    private var tickTimer: Timer?

    private init() {
        let seeded = Self.seedMatches()
        matches = seeded
        subject = CurrentValueSubject(seeded)
        if seeded.contains(where: { $0.isRunning }) {
            startTicker()
        }
    }

    func fetchMatches() -> [Match] {
        matches
    }

    func match(id: String) -> Match? {
        matches.first { $0.id == id }
    }

    func add(_ match: Match) {
        matches.insert(match, at: 0)
        publish()
        if match.isRunning { startTicker() }
    }

    func delete(id: String) {
        matches.removeAll { $0.id == id }
        publish()
        stopTickerIfIdle()
    }

    func toggleTimer(id: String) {
        guard let idx = matches.firstIndex(where: { $0.id == id }) else { return }
        if matches[idx].remainingSeconds <= 0 {
            matches[idx].remainingSeconds = Match.duration
            matches[idx].isRunning = true
        } else {
            matches[idx].isRunning.toggle()
        }
        publish()
        if matches[idx].isRunning {
            startTicker()
        } else {
            stopTickerIfIdle()
        }
    }

    func toggleFixedGK(matchId: String) {
        guard let idx = matches.firstIndex(where: { $0.id == matchId }) else { return }
        matches[idx].hasFixedGK.toggle()
        publish()
    }

    func addTeam(matchId: String) {
        guard let idx = matches.firstIndex(where: { $0.id == matchId }), matches[idx].teams.count < 4 else { return }
        let palette = Team.palette[matches[idx].teams.count]
        let team = Team(id: UUID().uuidString, name: palette.name, color: palette.color, players: [])
        matches[idx].teams.append(team)
        publish()
    }

    func removeTeam(matchId: String, teamId: String) {
        guard let idx = matches.firstIndex(where: { $0.id == matchId }) else { return }
        matches[idx].teams.removeAll { $0.id == teamId }
        publish()
    }

    func addPlayer(matchId: String, teamId: String) {
        guard let matchIdx = matches.firstIndex(where: { $0.id == matchId }),
              let teamIdx = matches[matchIdx].teams.firstIndex(where: { $0.id == teamId }) else { return }
        let maxPlayers = matches[matchIdx].hasFixedGK ? 6 : 5
        guard matches[matchIdx].teams[teamIdx].players.count < maxPlayers else { return }
        let nextNumber = matches[matchIdx].teams[teamIdx].players.count + 1
        matches[matchIdx].teams[teamIdx].players.append("Jogador \(nextNumber)")
        publish()
    }

    func removePlayer(matchId: String, teamId: String, index: Int) {
        guard let matchIdx = matches.firstIndex(where: { $0.id == matchId }),
              let teamIdx = matches[matchIdx].teams.firstIndex(where: { $0.id == teamId }),
              matches[matchIdx].teams[teamIdx].players.indices.contains(index) else { return }
        matches[matchIdx].teams[teamIdx].players.remove(at: index)
        publish()
    }

    private func publish() {
        subject.send(matches)
    }

    private func startTicker() {
        guard tickTimer == nil else { return }
        tickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func stopTickerIfIdle() {
        guard !matches.contains(where: { $0.isRunning }) else { return }
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func tick() {
        var changed = false
        for idx in matches.indices where matches[idx].isRunning {
            let next = matches[idx].remainingSeconds - 1
            if next <= 0 {
                matches[idx].remainingSeconds = 0
                matches[idx].isRunning = false
            } else {
                matches[idx].remainingSeconds = next
            }
            changed = true
        }
        if changed { publish() }
        stopTickerIfIdle()
    }

    private static func seedMatches() -> [Match] {
        let calendar = Calendar.current
        let now = Date()
        let fridayDate = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now) ?? now
        let sundayBase = calendar.date(byAdding: .day, value: 2, to: now) ?? now
        let sundayDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: sundayBase) ?? sundayBase

        return [
            Match(
                id: "1",
                title: "Pelada de Sexta",
                location: "Quadra Vila Olímpia",
                date: fridayDate,
                remainingSeconds: 274,
                isRunning: true,
                hasFixedGK: false,
                teams: [
                    Team(id: "a", name: Team.palette[0].name, color: Team.palette[0].color, players: ["Lucas", "Rafael", "Bruno", "Diego", "Thiago"]),
                    Team(id: "b", name: Team.palette[1].name, color: Team.palette[1].color, players: ["Matheus", "Gabriel", "Vinícius", "André", "Felipe"]),
                ]
            ),
            Match(
                id: "2",
                title: "Racha de Domingo",
                location: "Campo do Parque",
                date: sundayDate,
                remainingSeconds: Match.duration,
                isRunning: false,
                hasFixedGK: false,
                teams: []
            ),
        ]
    }
}
