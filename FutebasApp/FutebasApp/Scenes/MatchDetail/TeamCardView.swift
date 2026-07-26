//
//  TeamCardView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

final class TeamCardView: UIView {

    var onRemoveTeam: (() -> Void)?
    var onAddPlayer: (() -> Void)?
    var onRemovePlayer: ((Int) -> Void)?

    private let colorDot: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.captionBold
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let removeTeamButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)), for: .normal)
        button.tintColor = FutebasColors.textSecundary
        button.backgroundColor = FutebasColors.surfaceSecundary
        button.layer.cornerRadius = 11
        return button
    }()

    private let playersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.small
        return stack
    }()

    private let addPlayerButton: DashedBorderButton = {
        let button = DashedBorderButton(type: .system)
        button.setTitle("+ Adicionar jogador", for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = FutebasColors.surface
        layer.cornerRadius = FutebasRadius.medium
        layer.borderWidth = 1
        layer.borderColor = FutebasColors.border.cgColor
        buildViewHierarchy()
        buildConstraints()
        removeTeamButton.addTarget(self, action: #selector(didTapRemoveTeam), for: .touchUpInside)
        addPlayerButton.addTarget(self, action: #selector(didTapAddPlayer), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with team: MatchDetail.TeamViewModel) {
        colorDot.backgroundColor = team.color
        nameLabel.text = team.name
        addPlayerButton.isEnabled = team.canAddPlayer

        playersStack.arrangedSubviews.forEach {
            playersStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        team.players.forEach { player in
            playersStack.addArrangedSubview(playerRow(player))
        }
    }

    private func playerRow(_ player: MatchDetail.PlayerViewModel) -> UIView {
        let avatar = UILabel()
        avatar.text = player.initials
        avatar.font = FutebasTypography.small
        avatar.textColor = FutebasColors.textPrimary
        avatar.textAlignment = .center
        avatar.backgroundColor = FutebasColors.surfaceSecundary
        avatar.layer.cornerRadius = 13
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.widthAnchor.constraint(equalToConstant: 26).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 26).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = player.name
        nameLabel.font = FutebasTypography.caption
        nameLabel.textColor = FutebasColors.textPrimary

        let removeButton = UIButton(type: .system)
        removeButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 8, weight: .semibold)), for: .normal)
        removeButton.tintColor = FutebasColors.textTertiary
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        removeButton.tag = player.index
        removeButton.addTarget(self, action: #selector(didTapRemovePlayer(_:)), for: .touchUpInside)

        let row = UIStackView(arrangedSubviews: [avatar, nameLabel, removeButton])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = FutebasSpacing.small
        return row
    }

    @objc private func didTapRemoveTeam() {
        onRemoveTeam?()
    }

    @objc private func didTapAddPlayer() {
        onAddPlayer?()
    }

    @objc private func didTapRemovePlayer(_ sender: UIButton) {
        onRemovePlayer?(sender.tag)
    }

    private func buildViewHierarchy() {
        let headerRow = UIStackView(arrangedSubviews: [colorDot, nameLabel, UIView(), removeTeamButton])
        headerRow.axis = .horizontal
        headerRow.alignment = .center
        headerRow.spacing = FutebasSpacing.small - 2
        headerRow.tag = 200

        let outerStack = UIStackView(arrangedSubviews: [headerRow, playersStack, addPlayerButton])
        outerStack.axis = .vertical
        outerStack.spacing = FutebasSpacing.small + 2
        outerStack.tag = 201
        addSubview(outerStack)
    }

    private func buildConstraints() {
        guard let outerStack = viewWithTag(201), let headerRow = viewWithTag(200) else { return }
        [colorDot, removeTeamButton, addPlayerButton, outerStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: topAnchor, constant: FutebasSpacing.medium - 2),
            outerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: FutebasSpacing.medium - 2),
            outerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(FutebasSpacing.medium - 2)),
            outerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(FutebasSpacing.medium - 2)),

            colorDot.widthAnchor.constraint(equalToConstant: 8),
            colorDot.heightAnchor.constraint(equalToConstant: 8),

            removeTeamButton.widthAnchor.constraint(equalToConstant: 22),
            removeTeamButton.heightAnchor.constraint(equalToConstant: 22),

            addPlayerButton.heightAnchor.constraint(equalToConstant: 36),

            headerRow.widthAnchor.constraint(equalTo: outerStack.widthAnchor),
        ])
    }
}
