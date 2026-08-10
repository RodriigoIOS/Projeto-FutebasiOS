//
//  HomeView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

final class HomeView: UIView {

    /// Disparado quando o usuário toca em um item da barra — não importa se
    /// veio da `UITabBar` nativa ou do `FutebasCompatTabBar`.
    var onSelectTag: ((Int) -> Void)?

    /// Área onde a ViewController troca o child view controller da aba selecionada.
    let containerView: UIView = {
        let view = UIView()
        return view
    }()

    /// Só um dos dois é criado, dependendo da versão do iOS — ver
    /// `setupBottomBar()`. Ninguém fora desta view acessa `nativeTabBar` ou
    /// `compatTabBar` diretamente.
    private var nativeTabBar: UITabBar?
    private var compatTabBar: FutebasCompatTabBar?
    private let bottomBarContainer = UIView()

    private let items: [FutebasTabItem] = [
        FutebasTabItem(tag: 0, title: "Partidas", image: UIImage(systemName: "sportscourt")),
        FutebasTabItem(tag: 1, title: "Cronometro", image: UIImage(systemName: "stopwatch.fill")),
        FutebasTabItem(tag: 2, title: "Perfil", image: UIImage(systemName: "person.fill")),
    ]

    init() {
        super.init(frame: .zero)
        backgroundColor = FutebasColors.background
        setupBottomBar()
        buildViewHierarchy()
        buildConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Seleciona visualmente o item da barra, sem disparar `onSelectTag`
    /// (chamado pela ViewController ao decidir a aba inicial, não em resposta
    /// a um toque do usuário).
    func selectTag(_ tag: Int) {
        if #available(iOS 26.0, *) {
            nativeTabBar?.selectedItem = nativeTabBar?.items?.first { $0.tag == tag }
        } else {
            compatTabBar?.selectTag(tag)
        }
    }

    // MARK: - Bottom bar

    private func setupBottomBar() {
        // A partir do iOS 26 a UITabBar nativa já vira uma cápsula flutuante
        // com efeito de vidro (Liquid Glass) sozinha — é só usá-la normalmente
        // que o sistema cuida do visual. Em versões anteriores ela volta pro
        // visual clássico (reto, colado na borda), que destoa do resto do
        // app: nesse caso usamos o FutebasCompatTabBar, que desenha a mesma
        // ideia (cápsula flutuante + material translúcido) na mão.
        if #available(iOS 26.0, *) {
            let tabBar = UITabBar()
            tabBar.tintColor = FutebasColors.primary
            tabBar.unselectedItemTintColor = FutebasColors.textTertiary
            tabBar.backgroundColor = FutebasColors.surface
            tabBar.items = items.map { UITabBarItem(title: $0.title, image: $0.image, tag: $0.tag) }
            tabBar.selectedItem = tabBar.items?.first
            tabBar.delegate = self
            nativeTabBar = tabBar
            pin(tabBar, to: bottomBarContainer)
        } else {
            let tabBar = FutebasCompatTabBar()
            tabBar.setItems(items)
            tabBar.onSelectTag = { [weak self] tag in
                self?.onSelectTag?(tag)
            }
            compatTabBar = tabBar
            pin(tabBar, to: bottomBarContainer)
        }
    }

    private func pin(_ view: UIView, to container: UIView) {
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }

    // MARK: - Layout

    private func buildViewHierarchy() {
        [containerView, bottomBarContainer].forEach { addSubview($0) }
    }

    private func buildConstraints() {
        [containerView, bottomBarContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomBarContainer.topAnchor),
        ])

        if #available(iOS 26.0, *) {
            // A UITabBar nativa já trata o respiro do home indicator sozinha
            // e é edge-to-edge, então o container vai até a borda de verdade.
            NSLayoutConstraint.activate([
                bottomBarContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottomBarContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                bottomBarContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        } else {
            // A cápsula flutuante do fallback precisa de margem própria dos
            // dois lados e de baixo — senão ela cola na borda/no home
            // indicator, o que quebra a ideia de "flutuar" sobre o conteúdo.
            NSLayoutConstraint.activate([
                bottomBarContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FutebasSpacing.large),
                bottomBarContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FutebasSpacing.large),
                bottomBarContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -FutebasSpacing.small),
                bottomBarContainer.heightAnchor.constraint(equalToConstant: 64),
            ])
        }
    }
}

extension HomeView: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        onSelectTag?(item.tag)
    }
}
