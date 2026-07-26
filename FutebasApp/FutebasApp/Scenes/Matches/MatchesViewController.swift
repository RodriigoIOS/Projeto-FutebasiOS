//
//  MatchesViewController.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

protocol MatchesDisplayLogic: AnyObject {
    func displayMatches(_ viewModel: Matches.Fetch.ViewModel)
}

final class MatchesViewController: UIViewController {

    var interactor: MatchesBusinessLogic?
    weak var coordinator: MatchesCoordinator?

    private var cells: [Matches.Fetch.Cell] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Partidas"
        label.font = FutebasTypography.largeTitle
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = FutebasColors.primary
        button.layer.cornerRadius = 20
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let footerHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Deslize um card para a esquerda para excluir · duração da partida: 08:00"
        label.font = FutebasTypography.small
        label.textColor = FutebasColors.textTertiary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhuma partida criada ainda.\nToque em + para organizar sua primeira pelada."
        label.font = FutebasTypography.body
        label.textColor = FutebasColors.textSecundary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVIP() {
        let interactor = MatchesInteractor()
        let presenter = MatchesPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = FutebasColors.background
        buildViewHierarchy()
        buildConstraints()
        configureTableView()
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        interactor?.fetchMatches(Matches.Fetch.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MatchCell.self, forCellReuseIdentifier: MatchCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }

    @objc private func didTapAdd() {
        coordinator?.routeToCreateMatch()
    }

    private func buildViewHierarchy() {
        [titleLabel, addButton, tableView, footerHintLabel, emptyStateLabel].forEach { view.addSubview($0) }
    }

    private func buildConstraints() {
        [titleLabel, addButton, tableView, footerHintLabel, emptyStateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: FutebasSpacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),

            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.large),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FutebasSpacing.small),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerHintLabel.topAnchor, constant: -FutebasSpacing.small),

            footerHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),
            footerHintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.large),
            footerHintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -FutebasSpacing.small),

            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.xLarge),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.xLarge),
        ])
    }
}

extension MatchesViewController: MatchesDisplayLogic {
    func displayMatches(_ viewModel: Matches.Fetch.ViewModel) {
        cells = viewModel.cells
        tableView.isHidden = viewModel.isEmpty
        footerHintLabel.isHidden = viewModel.isEmpty
        emptyStateLabel.isHidden = !viewModel.isEmpty
        tableView.reloadData()
    }
}

extension MatchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchCell.reuseIdentifier, for: indexPath) as? MatchCell else {
            return UITableViewCell()
        }
        let matchCell = cells[indexPath.row]
        cell.configure(with: matchCell)
        cell.onToggle = { [weak self] in
            self?.interactor?.toggleTimer(Matches.ToggleTimer.Request(id: matchCell.id))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.routeToDetail(matchId: cells[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let matchCell = cells[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] _, _, completion in
            self?.interactor?.deleteMatch(Matches.DeleteMatch.Request(id: matchCell.id))
            completion(true)
        }
        delete.backgroundColor = FutebasColors.danger
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
