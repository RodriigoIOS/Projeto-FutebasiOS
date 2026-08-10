//
//  FutebasCompatTabBar.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Tab bar "estilo Liquid Glass" desenhada na mão, pra usar em iOS < 26.
///
/// A partir do iOS 26 a `UITabBar` nativa vira sozinha uma cápsula flutuante
/// com efeito de vidro (Liquid Glass) — zero código extra. Em versões
/// anteriores ela volta pro visual clássico (barra reta, colada na borda),
/// que destoa do resto do app. Esta view replica manualmente a mesma ideia
/// visual (cápsula flutuante + material translúcido) usando
/// `UIVisualEffectView`, pra manter a identidade visual parecida em qualquer
/// versão do iOS.
///
/// Quem decide qual das duas (`UITabBar` nativa ou esta) usar é a
/// `HomeView`, checando `#available(iOS 26, *)`. O resto do app
/// (`HomeViewController`) não sabe qual das duas está ativa — só usa a API
/// comum que a `HomeView` expõe (`onSelectTag`, `selectTag`).
final class FutebasCompatTabBar: UIView {

    var onSelectTag: ((Int) -> Void)?

    private var buttons: [UIButton] = []
    private var selectedTag: Int = 0

    /// Container que realmente recorta os cantos em formato de cápsula.
    /// A sombra fica na view de fora (`self`), que não tem `clipsToBounds` —
    /// sombra e corner clipping não convivem bem na mesma camada, por isso
    /// são separadas em duas views.
    private let capsuleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = FutebasColors.border.withAlphaComponent(0.6).cgColor
        view.clipsToBounds = true
        return view
    }()

    /// `.systemChromeMaterial` é o blur mais próximo do "vidro" usado pelas
    /// barras do sistema — é o que dá a sensação de translucidez do Liquid
    /// Glass sem precisar simular refração de verdade.
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupShadow()
        buildViewHierarchy()
        buildConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Cápsula de verdade: raio = metade da altura atual, recalculado a
        // cada layout (a altura vem de constraints externas, não é fixa aqui).
        let radius = capsuleView.bounds.height / 2
        capsuleView.layer.cornerRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: capsuleView.frame, cornerRadius: radius).cgPath
    }

    // MARK: - Configuração

    func setItems(_ items: [FutebasTabItem]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = items.map(makeButton)
        buttons.forEach { stackView.addArrangedSubview($0) }
        refreshSelectionAppearance()
    }

    func selectTag(_ tag: Int) {
        selectedTag = tag
        refreshSelectionAppearance()
    }

    // MARK: - Botões

    private func makeButton(for item: FutebasTabItem) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = item.image
        config.title = item.title
        config.imagePlacement = .top
        config.imagePadding = FutebasSpacing.xSmall
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FutebasTypography.small
            return outgoing
        }

        let button = UIButton(configuration: config)
        button.tag = item.tag
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }

    @objc private func didTapButton(_ sender: UIButton) {
        selectedTag = sender.tag
        refreshSelectionAppearance()
        onSelectTag?(sender.tag)
    }

    private func refreshSelectionAppearance() {
        buttons.forEach { button in
            let color = button.tag == selectedTag ? FutebasColors.primary : FutebasColors.textTertiary
            button.configuration?.baseForegroundColor = color
        }
    }

    // MARK: - Layout

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    private func buildViewHierarchy() {
        addSubview(capsuleView)
        capsuleView.addSubview(blurView)
        capsuleView.addSubview(stackView)
    }

    private func buildConstraints() {
        [capsuleView, blurView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            capsuleView.topAnchor.constraint(equalTo: topAnchor),
            capsuleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            capsuleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: bottomAnchor),

            blurView.topAnchor.constraint(equalTo: capsuleView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: FutebasSpacing.small),
            stackView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: FutebasSpacing.medium),
            stackView.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -FutebasSpacing.medium),
            stackView.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -FutebasSpacing.small),
        ])
    }
}
