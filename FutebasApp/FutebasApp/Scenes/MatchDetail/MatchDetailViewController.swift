//
//  MatchDetailViewController.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

protocol MatchDetailDisplayLogic: AnyObject {
    func displayMatch(_ viewModel: MatchDetail.Fetch.ViewModel)
    func displayNotFound()
}

final class MatchDetailViewController: UIViewController {

    var interactor: MatchDetailBusinessLogic?
    weak var coordinator: MatchesCoordinator?

    private let matchId: String
    private var currentViewModel: MatchDetail.Fetch.ViewModel?

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        button.tintColor = FutebasColors.textPrimary
        button.backgroundColor = FutebasColors.surfaceSecundary
        button.layer.cornerRadius = 17
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FutebasTypography.subTitle
        label.textColor = FutebasColors.textPrimary
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let scrollView = UIScrollView()

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

    private let timerCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Cronômetro · partida de 08:00".uppercased()
        label.font = FutebasTypography.small
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 36, weight: .bold)
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let timerToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = FutebasColors.primary
        button.tintColor = .white
        button.layer.cornerRadius = 28
        return button
    }()

    private let teamsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Times sorteados".uppercased()
        label.font = FutebasTypography.small
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private let gkLabel: UILabel = {
        let label = UILabel()
        label.text = "Goleiro fixo"
        label.font = FutebasTypography.caption
        label.textColor = FutebasColors.textSecundary
        return label
    }()

    private let gkToggle = ToggleSwitchView()

    private let emptyTeamsView: DashedBorderView = {
        let view = DashedBorderView()
        let label = UILabel()
        label.text = "Nenhum time criado ainda."
        label.font = FutebasTypography.caption
        label.textColor = FutebasColors.textSecundary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: FutebasSpacing.large - 4),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(FutebasSpacing.large - 4)),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.medium),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.medium),
        ])
        return view
    }()

    private let teamsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.medium - 4
        return stack
    }()

    private let addTeamButton: DashedBorderButton = {
        let button = DashedBorderButton(type: .system)
        button.setTitle("+ Adicionar time", for: .normal)
        return button
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.large - 4
        return stack
    }()

    init(matchId: String) {
        self.matchId = matchId
        super.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVIP() {
        let interactor = MatchDetailInteractor(matchId: matchId)
        let presenter = MatchDetailPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = FutebasColors.background
        buildViewHierarchy()
        buildConstraints()
        wireActions()
        interactor?.fetchMatch(MatchDetail.Fetch.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func wireActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        timerToggleButton.addTarget(self, action: #selector(didTapTimerToggle), for: .touchUpInside)
        gkToggle.addTarget(self, action: #selector(didToggleGK), for: .valueChanged)
        addTeamButton.addTarget(self, action: #selector(didTapAddTeam), for: .touchUpInside)
    }

    @objc private func didTapBack() {
        coordinator?.pop()
    }

    @objc private func didTapTimerToggle() {
        interactor?.toggleTimer(MatchDetail.ToggleTimer.Request())
    }

    @objc private func didToggleGK() {
        interactor?.toggleFixedGK(MatchDetail.ToggleFixedGK.Request())
    }

    @objc private func didTapAddTeam() {
        interactor?.addTeam(MatchDetail.AddTeam.Request())
    }

    private func infoCard() -> UIView {
        let card = UIView()
        card.backgroundColor = FutebasColors.surface
        card.layer.cornerRadius = FutebasRadius.medium
        card.layer.borderWidth = 1
        card.layer.borderColor = FutebasColors.border.cgColor

        [locationIcon, locationLabel, dateIcon, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }

        NSLayoutConstraint.activate([
            locationIcon.topAnchor.constraint(equalTo: card.topAnchor, constant: FutebasSpacing.medium),
            locationIcon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: FutebasSpacing.medium),
            locationIcon.widthAnchor.constraint(equalToConstant: 14),
            locationIcon.heightAnchor.constraint(equalToConstant: 14),

            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -FutebasSpacing.medium),

            dateIcon.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: FutebasSpacing.small + 2),
            dateIcon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: FutebasSpacing.medium),
            dateIcon.widthAnchor.constraint(equalToConstant: 14),
            dateIcon.heightAnchor.constraint(equalToConstant: 14),
            dateIcon.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -FutebasSpacing.medium),

            dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 8),
        ])
        return card
    }

    private func timerCard() -> UIView {
        let card = UIView()
        card.backgroundColor = FutebasColors.surface
        card.layer.cornerRadius = FutebasRadius.medium
        card.layer.borderWidth = 1
        card.layer.borderColor = FutebasColors.border.cgColor

        [timerCaptionLabel, timerLabel, timerToggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }

        NSLayoutConstraint.activate([
            timerCaptionLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: FutebasSpacing.large - 4),
            timerCaptionLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            timerLabel.topAnchor.constraint(equalTo: timerCaptionLabel.bottomAnchor, constant: FutebasSpacing.small + 2),
            timerLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            timerToggleButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: FutebasSpacing.medium - 2),
            timerToggleButton.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            timerToggleButton.widthAnchor.constraint(equalToConstant: 56),
            timerToggleButton.heightAnchor.constraint(equalToConstant: 56),
            timerToggleButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -(FutebasSpacing.large - 4)),
        ])
        return card
    }

    private func teamsSection() -> UIView {
        let container = UIView()

        let gkRow = UIStackView(arrangedSubviews: [gkLabel, gkToggle])
        gkRow.axis = .horizontal
        gkRow.alignment = .center
        gkRow.spacing = FutebasSpacing.small

        let headerRow = UIStackView(arrangedSubviews: [teamsHeaderLabel, UIView(), gkRow])
        headerRow.axis = .horizontal
        headerRow.alignment = .center

        let sectionStack = UIStackView(arrangedSubviews: [headerRow, emptyTeamsView, teamsStack, addTeamButton])
        sectionStack.axis = .vertical
        sectionStack.spacing = FutebasSpacing.medium - 4
        sectionStack.translatesAutoresizingMaskIntoConstraints = false
        addTeamButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        emptyTeamsView.dashCornerRadius = FutebasRadius.medium

        container.addSubview(sectionStack)
        NSLayoutConstraint.activate([
            sectionStack.topAnchor.constraint(equalTo: container.topAnchor),
            sectionStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            sectionStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            sectionStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        return container
    }

    private func buildViewHierarchy() {
        [backButton, titleLabel, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStack)
        [infoCard(), timerCard(), teamsSection()].forEach { contentStack.addArrangedSubview($0) }
    }

    private func buildConstraints() {
        [backButton, titleLabel, scrollView, contentStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: FutebasSpacing.medium),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),
            backButton.widthAnchor.constraint(equalToConstant: 34),
            backButton.heightAnchor.constraint(equalToConstant: 34),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: FutebasSpacing.small + 2),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.large),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: FutebasSpacing.medium),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: FutebasSpacing.large),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -FutebasSpacing.large),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -FutebasSpacing.large),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -FutebasSpacing.large * 2),
        ])
    }

    private func rebuildTeamCards(_ teams: [MatchDetail.TeamViewModel]) {
        teamsStack.arrangedSubviews.forEach {
            teamsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        teams.forEach { team in
            let card = TeamCardView()
            card.configure(with: team)
            card.onRemoveTeam = { [weak self] in
                self?.interactor?.removeTeam(MatchDetail.RemoveTeam.Request(teamId: team.id))
            }
            card.onAddPlayer = { [weak self] in
                self?.interactor?.addPlayer(MatchDetail.AddPlayer.Request(teamId: team.id))
            }
            card.onRemovePlayer = { [weak self] index in
                self?.interactor?.removePlayer(MatchDetail.RemovePlayer.Request(teamId: team.id, index: index))
            }
            teamsStack.addArrangedSubview(card)
        }
    }
}

extension MatchDetailViewController: MatchDetailDisplayLogic {
    func displayMatch(_ viewModel: MatchDetail.Fetch.ViewModel) {
        currentViewModel = viewModel

        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.location
        dateLabel.text = viewModel.displayDate
        timerLabel.text = viewModel.displayTimer

        let iconName = viewModel.isRunning ? "pause.fill" : "play.fill"
        timerToggleButton.setImage(UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)

        gkToggle.setOn(viewModel.hasFixedGK, animated: false)

        emptyTeamsView.isHidden = !viewModel.teams.isEmpty
        teamsStack.isHidden = viewModel.teams.isEmpty
        rebuildTeamCards(viewModel.teams)

        addTeamButton.isEnabled = viewModel.canAddTeam
    }

    func displayNotFound() {
        coordinator?.pop()
    }
}
