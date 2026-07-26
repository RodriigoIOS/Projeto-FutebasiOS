//
//  CreateMatchInteractor.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

protocol CreateMatchBusinessLogic {
    func validateForm(_ request: CreateMatch.FormChanged.Request)
    func saveMatch(_ request: CreateMatch.Save.Request)
}

final class CreateMatchInteractor: CreateMatchBusinessLogic {

    var presenter: CreateMatchPresentationLogic?
    var worker = CreateMatchWorker()

    func validateForm(_ request: CreateMatch.FormChanged.Request) {
        let isEnabled = !request.title.trimmingCharacters(in: .whitespaces).isEmpty
            && !request.location.trimmingCharacters(in: .whitespaces).isEmpty
        presenter?.presentFormState(CreateMatch.FormChanged.Response(isSaveEnabled: isEnabled))
    }

    func saveMatch(_ request: CreateMatch.Save.Request) {
        let title = request.title.trimmingCharacters(in: .whitespaces)
        let location = request.location.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty, !location.isEmpty else { return }

        let baseDate = Self.parseDate(request.date) ?? Date()
        let date = Self.applyTime(request.time, to: baseDate)

        let match = Match(
            id: UUID().uuidString,
            title: title,
            location: location,
            date: date,
            remainingSeconds: Match.duration,
            isRunning: false,
            hasFixedGK: false,
            teams: []
        )
        worker.save(match)
        presenter?.presentSaved()
    }

    // Réplica do parsing de "dd/mm/aaaa" feito no protótipo (saveMatch).
    private static func parseDate(_ text: String) -> Date? {
        let parts = text.split(separator: "/").compactMap { Int($0) }
        guard parts.count >= 2 else { return nil }
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = parts.count > 2 ? (parts[2] < 100 ? 2000 + parts[2] : parts[2]) : currentYear
        var components = DateComponents()
        components.day = parts[0]
        components.month = parts[1]
        components.year = year
        return Calendar.current.date(from: components)
    }

    // Réplica do parsing de "hh:mm" do protótipo, com fallback para 19:00.
    private static func applyTime(_ text: String, to date: Date) -> Date {
        let calendar = Calendar.current
        let parts = text.split(separator: ":").compactMap { Int($0) }
        guard let hour = parts.first else {
            return calendar.date(bySettingHour: 19, minute: 0, second: 0, of: date) ?? date
        }
        let minute = parts.count > 1 ? parts[1] : 0
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? date
    }
}
