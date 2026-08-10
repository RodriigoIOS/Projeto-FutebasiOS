//
//  FutebasTabItem.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Descrição neutra de um item de tab bar — não amarrada a `UITabBarItem`
/// nem a nenhum componente específico. A `HomeView` usa a mesma lista de
/// `FutebasTabItem` pra alimentar tanto a `UITabBar` nativa (iOS 26+) quanto
/// o `FutebasCompatTabBar` (iOS < 26), evitando duplicar título/ícone/tag em
/// dois lugares diferentes.
struct FutebasTabItem {
    let tag: Int
    let title: String
    let image: UIImage?
}
