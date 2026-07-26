//
//  MatchCell.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

final class MatchCell: UITableViewCell {

    static let reuseIdentifier = "MatchCell"

    var onToggle: (() -> Void)?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = FutebasColors.surface
        view.layer.cornerRadius = FutebasRadius.medium
        view.layer.borderWidth = 1
        view.layer.borderColor = FutebasColors.border.cgColor
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.button
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let badgeContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = FutebasRadius.pill
        return view
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.small
        return label
    }()

    private let locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        imageView.tintColor = FutebasColors.textSecundary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.caption
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private let dateIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.tintColor = FutebasColors.textSecundary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.caption
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.captionBold
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = FutebasColors.primary
        button.tintColor = .white
        button.layer.cornerRadius = 14
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        buildViewHierarchy()
        buildConstraints()
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cell: Matches.Fetch.Cell) {
        titleLabel.text = cell.title
        locationLabel.text = cell.location
        dateLabel.text = cell.displayDate
        timerLabel.text = cell.displayTimer

        if cell.isRunning {
            badgeContainer.isHidden = false
            badgeContainer.backgroundColor = FutebasColors.primaryLight
            badgeLabel.textColor = FutebasColors.primaryDark
            badgeLabel.text = "Em andamento"
        } else if cell.isEnded {
            badgeContainer.isHidden = false
            badgeContainer.backgroundColor = FutebasColors.surfaceSecundary
            badgeLabel.textColor = FutebasColors.textSecundary
            badgeLabel.text = "Encerrada"
        } else {
            badgeContainer.isHidden = true
        }

        let iconName = cell.isRunning ? "pause.fill" : "play.fill"
        toggleButton.setImage(UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
    }

    @objc private func didTapToggle() {
        onToggle?()
    }

    private func buildViewHierarchy() {
        contentView.addSubview(cardView)
        [titleLabel, badgeContainer, locationIcon, locationLabel, dateIcon, dateLabel, timerLabel, toggleButton].forEach {
            cardView.addSubview($0)
        }
        badgeContainer.addSubview(badgeLabel)
    }

    private func buildConstraints() {
        [cardView, titleLabel, badgeContainer, badgeLabel, locationIcon, locationLabel, dateIcon, dateLabel, timerLabel, toggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: FutebasSpacing.small / 2),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: FutebasSpacing.medium),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -FutebasSpacing.medium),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -FutebasSpacing.small / 2),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: FutebasSpacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: FutebasSpacing.medium),

            badgeContainer.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeContainer.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: FutebasSpacing.small),
            badgeContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -FutebasSpacing.medium),

            badgeLabel.topAnchor.constraint(equalTo: badgeContainer.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -4),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor, constant: 9),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: -9),

            locationIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FutebasSpacing.small),
            locationIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: FutebasSpacing.medium),
            locationIcon.widthAnchor.constraint(equalToConstant: 14),
            locationIcon.heightAnchor.constraint(equalToConstant: 14),

            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 6),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -FutebasSpacing.medium),

            dateIcon.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: FutebasSpacing.small),
            dateIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: FutebasSpacing.medium),
            dateIcon.widthAnchor.constraint(equalToConstant: 14),
            dateIcon.heightAnchor.constraint(equalToConstant: 14),
            dateIcon.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -FutebasSpacing.medium),

            dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 6),

            toggleButton.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -FutebasSpacing.medium),
            toggleButton.widthAnchor.constraint(equalToConstant: 28),
            toggleButton.heightAnchor.constraint(equalToConstant: 28),

            timerLabel.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -FutebasSpacing.small),
            timerLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: FutebasSpacing.small),
        ])
    }
}
