//
//  ProfileFieldRowView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Uma linha editável dentro de um card de perfil: título em cima e o
/// controle de edição embaixo. Qual controle aparece (UITextField ou
/// UISegmentedControl) depende só do `Profile.Field.Kind` — esta view não
/// decide nada sozinha, apenas reage ao dado que recebe em `configure(with:)`.
///
/// Para suportar um novo tipo de campo (ex: data de nascimento com
/// UIDatePicker), adicione um case em `Profile.Field.Kind` e trate ele aqui
/// dentro do switch de `configure(with:)`.
final class ProfileFieldRowView: UIView {

    /// Disparado a cada edição, sempre como texto — mesmo quando a origem é
    /// um UISegmentedControl, convertemos pro título da opção escolhida.
    var onChange: ((String) -> Void)?

    private var field: Profile.Field?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.captionBold
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private lazy var textField: FutebasTextField = {
        let textField = FutebasTextField(placeholder: "")
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentTintColor = FutebasColors.primary
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: FutebasColors.textPrimary], for: .normal)
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()

    private let controlsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    init() {
        super.init(frame: .zero)
        buildViewHierarchy()
        buildConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Popula a row a partir do `Field` e decide qual controle mostrar.
    func configure(with field: Profile.Field) {
        self.field = field
        titleLabel.text = field.title

        switch field.kind {
        case .text:
            segmentedControl.isHidden = true
            textField.isHidden = false
            textField.placeholder = field.placeholder
            textField.text = field.value

        case .options(let options):
            textField.isHidden = true
            segmentedControl.isHidden = false
            segmentedControl.removeAllSegments()
            options.enumerated().forEach { index, option in
                segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
            }
            segmentedControl.selectedSegmentIndex = options.firstIndex(of: field.value) ?? UISegmentedControl.noSegment
        }
    }

    @objc private func textFieldChanged() {
        onChange?(textField.text ?? "")
    }

    @objc private func segmentChanged() {
        guard case .options(let options) = field?.kind,
              segmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment else { return }
        onChange?(options[segmentedControl.selectedSegmentIndex])
    }

    private func buildViewHierarchy() {
        [textField, segmentedControl].forEach { controlsStack.addArrangedSubview($0) }
        [titleLabel, controlsStack].forEach { addSubview($0) }
    }

    private func buildConstraints() {
        [titleLabel, controlsStack, textField, segmentedControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            controlsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FutebasSpacing.xSmall),
            controlsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlsStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            textField.heightAnchor.constraint(equalToConstant: 44),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
}
