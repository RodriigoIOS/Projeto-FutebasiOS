//
//  MatchFormatting.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import Foundation

/// Formatação compartilhada entre os Presenters das cenas de partida.
enum MatchFormatting {

    static func timer(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    static func date(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "'Hoje,' HH:mm"
        } else {
            formatter.dateFormat = "dd/MM, HH:mm"
        }
        return formatter.string(from: date)
    }
}
