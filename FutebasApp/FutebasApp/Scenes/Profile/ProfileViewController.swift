//
//  ProfileViewController.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 10/08/26.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayProfile(_ viewModel: Profile.Load.ViewModel)
}

final class ProfileViewController: UIViewController {

    var interactor: ProfileBusinessLogic?
    weak var coordinator: ProfileCoordinator?

    private let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.onFieldChange = { [weak self] id, newValue in
            self?.interactor?.updateField(Profile.UpdateField.Request(id: id, newValue: newValue))
        }

        interactor?.loadProfile(Profile.Load.Request())
    }
}

extension ProfileViewController: ProfileDisplayLogic {
    func displayProfile(_ viewModel: Profile.Load.ViewModel) {
        profileView.configure(sections: viewModel.sections)
    }
}
