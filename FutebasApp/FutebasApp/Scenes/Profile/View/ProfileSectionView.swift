//
//  ProfileSectionView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

/// Card com borda (mesmo estilo visual dos boxes "O que melhoramos" / "Os
/// cuidados que continuam" da referência que você mandou) que agrupa as rows
/// de uma `Profile.Section`. Não conhece Interactor nem Presenter — só recebe
/// dados prontos via `configure(with:)` e devolve edições via `onFieldChange`.
final class ProfileSectionView: UIView {

    /// (id do field editado, novo valor)
    var onFieldChange: ((String, String) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.subTitle
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let fieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.medium
        return stack
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = FutebasColors.surface
        layer.cornerRadius = FutebasRadius.medium
        layer.borderWidth = 1
        layer.borderColor = FutebasColors.border.cgColor
        buildViewHierarchy()
        buildConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Recria as rows a partir da seção. Como cada row nasce de um
    /// `Profile.Field`, adicionar um campo novo em `section.fields` (lá no
    /// Interactor) já aparece aqui automaticamente — este arquivo não muda.
    func configure(with section: Profile.Section) {
        titleLabel.text = section.title

        fieldsStack.arrangedSubviews.forEach {
            fieldsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        section.fields.forEach { field in
            let row = ProfileFieldRowView()
            row.configure(with: field)
            row.onChange = { [weak self] newValue in
                self?.onFieldChange?(field.id, newValue)
            }
            fieldsStack.addArrangedSubview(row)
        }
    }

    private func buildViewHierarchy() {
        [titleLabel, fieldsStack].forEach { addSubview($0) }
    }

    private func buildConstraints() {
        [titleLabel, fieldsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: FutebasSpacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FutebasSpacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FutebasSpacing.medium),

            fieldsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FutebasSpacing.medium),
            fieldsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FutebasSpacing.medium),
            fieldsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -FutebasSpacing.medium),
            fieldsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FutebasSpacing.medium),
        ])
    }
}
