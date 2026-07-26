//
//  CreateMatchViewController.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

protocol CreateMatchDisplayLogic: AnyObject {
    func displayFormState(_ viewModel: CreateMatch.FormChanged.ViewModel)
    func displaySaved()
}

final class CreateMatchViewController: UIViewController {

    var interactor: CreateMatchBusinessLogic?
    weak var coordinator: MatchesCoordinator?

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        button.tintColor = FutebasColors.textPrimary
        button.backgroundColor = FutebasColors.surfaceSecundary
        button.layer.cornerRadius = 17
        return button
    }()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nova Partida"
        label.font = FutebasTypography.subTitle
        label.textColor = FutebasColors.textPrimary
        return label
    }()

    private let titleField = FutebasTextField(placeholder: "Ex: Pelada de sexta")
    private let locationField = FutebasTextField(placeholder: "Ex: Quadra do bairro")
    private let dateField = FutebasTextField(placeholder: "22/07/2026")
    private let timeField = FutebasTextField(placeholder: "19:00")

    private let saveButton = FutebasButton(title: "Salvar Partida", style: .primary)
    private let formStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupVIP()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVIP() {
        let interactor = CreateMatchInteractor()
        let presenter = CreateMatchPresenter()
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
        updateSaveButtonState(isEnabled: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func wireActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        [titleField, locationField, dateField, timeField].forEach {
            $0.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        }
    }

    @objc private func didTapBack() {
        coordinator?.pop()
    }

    @objc private func fieldsChanged() {
        interactor?.validateForm(
            CreateMatch.FormChanged.Request(
                title: titleField.text ?? "",
                location: locationField.text ?? "",
                date: dateField.text ?? "",
                time: timeField.text ?? ""
            )
        )
    }

    @objc private func didTapSave() {
        interactor?.saveMatch(
            CreateMatch.Save.Request(
                title: titleField.text ?? "",
                location: locationField.text ?? "",
                date: dateField.text ?? "",
                time: timeField.text ?? ""
            )
        )
    }

    private func updateSaveButtonState(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1 : 0.45
    }

    private func fieldLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = FutebasTypography.captionBold
        label.textColor = FutebasColors.textSecundary
        return label
    }

    private func fieldGroup(label: UILabel, field: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, field])
        stack.axis = .vertical
        stack.spacing = FutebasSpacing.xSmall + 2
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return stack
    }

    private func buildViewHierarchy() {
        [backButton, headerTitleLabel].forEach { view.addSubview($0) }

        let titleGroup = fieldGroup(label: fieldLabel("Título"), field: titleField)
        let locationGroup = fieldGroup(label: fieldLabel("Local"), field: locationField)
        let dateGroup = fieldGroup(label: fieldLabel("Data"), field: dateField)
        let timeGroup = fieldGroup(label: fieldLabel("Hora"), field: timeField)

        let dateTimeRow = UIStackView(arrangedSubviews: [dateGroup, timeGroup])
        dateTimeRow.axis = .horizontal
        dateTimeRow.spacing = 12
        dateTimeRow.distribution = .fillEqually

        [titleGroup, locationGroup, dateTimeRow].forEach { formStack.addArrangedSubview($0) }
        formStack.spacing = FutebasSpacing.large - 6
        view.addSubview(formStack)

        view.addSubview(saveButton)
    }

    private func buildConstraints() {
        [backButton, headerTitleLabel, saveButton, formStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: FutebasSpacing.medium),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),
            backButton.widthAnchor.constraint(equalToConstant: 34),
            backButton.heightAnchor.constraint(equalToConstant: 34),

            headerTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: FutebasSpacing.small + 2),

            formStack.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: FutebasSpacing.large),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.large),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FutebasSpacing.large),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FutebasSpacing.large),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -FutebasSpacing.large),
        ])
    }
}

extension CreateMatchViewController: CreateMatchDisplayLogic {
    func displayFormState(_ viewModel: CreateMatch.FormChanged.ViewModel) {
        updateSaveButtonState(isEnabled: viewModel.isSaveEnabled)
    }

    func displaySaved() {
        coordinator?.pop()
    }
}
