//
//  ProfileView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Tela de edição de perfil: um título fixo no topo e, embaixo, uma
/// UIScrollView com um UIStackView vertical dentro — cada item desse stack é
/// um `ProfileSectionView` (um card por `Profile.Section`).
///
/// Como adicionar uma seção nova (ex: "Preferências de jogo") sem tocar em
/// nenhum arquivo de View:
/// 1. Abra `ProfileInteractor` e adicione um `Profile.Section(title:fields:)`
///    novo ao array `sections`.
/// 2. Pronto. `configure(sections:)` abaixo itera o array e cria um
///    `ProfileSectionView` pra cada item — esta tela não sabe (nem precisa
///    saber) quantas seções existem.
///
/// Mesma lógica pra um campo novo dentro de uma seção já existente: só
/// adicionar um `Profile.Field` na lista `fields` daquela seção.
final class ProfileView: UIView {

    /// (id do field editado, novo valor) — repassado direto do card que
    /// disparou a edição.
    var onFieldChange: ((String, String) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Meu Perfil"
        label.font = FutebasTypography.largeTitle
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let sectionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.medium
        return stack
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = FutebasColors.background
        buildViewHierarchy()
        buildConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Recebe as seções já prontas (vindas do `Profile.Load.ViewModel` via
    /// ViewController) e desenha um card por seção.
    func configure(sections: [Profile.Section]) {
        sectionsStack.arrangedSubviews.forEach {
            sectionsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        sections.forEach { section in
            let sectionView = ProfileSectionView()
            sectionView.configure(with: section)
            sectionView.onFieldChange = { [weak self] id, newValue in
                self?.onFieldChange?(id, newValue)
            }
            sectionsStack.addArrangedSubview(sectionView)
        }
    }

    private func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(scrollView)
        scrollView.addSubview(sectionsStack)
    }

    private func buildConstraints() {
        [titleLabel, scrollView, sectionsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: FutebasSpacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FutebasSpacing.large),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FutebasSpacing.small),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // sectionsStack ancorado no contentLayoutGuide (define a área de
            // conteúdo/scroll) e sua largura travada no frameLayoutGuide (a
            // largura visível da tela) — é isso que evita scroll horizontal e
            // faz os cards ocuparem a largura da tela mesmo dentro de um scroll.
            sectionsStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: FutebasSpacing.medium),
            sectionsStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: FutebasSpacing.large),
            sectionsStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -FutebasSpacing.large),
            sectionsStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -FutebasSpacing.large),
        ])
    }
}
