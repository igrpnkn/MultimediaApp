//
//  ProfileViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                print("\nINFO: Model has beeb got! ")
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}
