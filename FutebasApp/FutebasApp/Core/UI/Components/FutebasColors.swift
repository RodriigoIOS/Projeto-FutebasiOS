//
//  FutebasColors.swift
//  FutebasApp
//
//  Created by Rodrigo Garcia on 29/04/26.
// Essa classe é referente as principais cores que seráo utilizados dentro do aplicativo, a ideia é que náo seje utilizado via hard coded.

import UIKit

enum FutebasColors {
    
    static let primary = UIColor(red: 0.05, green: 0.62, blue: 0.25, alpha: 1.0)
    static let primaryDark = UIColor(red: 0.02 , green: 0.38, blue: 0.15, alpha: 1.0)
    static let primaryLight = UIColor(red: 0.83, green: 0.96, blue: 0.88, alpha: 1.0)
    
    static let background = UIColor(red: 0.96, green: 0.98, blue: 0.97, alpha: 1.0)
    static let surface = UIColor.white
    static let surfaceSecundary = UIColor(red: 0.93, green: 0.95, blue: 0.94, alpha: 1.0)
    
    static let textPrimary = UIColor(red: 0.04, green: 0.07, blue: 0.06, alpha: 1.0)
    static let textSecundary = UIColor(red: 0.39, green: 0.45, blue: 0.42, alpha: 1.0)
    static let textTertiary = UIColor(red: 0.63, green: 0.68, blue: 0.65, alpha: 1.0)
    
    static let border = UIColor(red: 0.84, green: 0.89, blue: 0.86, alpha: 1.0)
    
    static let success = primary
    static let warning = UIColor(red: 0.95, green: 0.63, blue: 0.12, alpha: 1.0)
    static let danger = UIColor(red: 0.91, green: 0.22, blue: 0.22, alpha: 1.0)
    
    //MARK: - Caso seja necessário novas cores, verificar o padrao do aplicativo, para que náo fuja as cores originais do app.
}

