//
//  UserViewController.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

public class UserViewController: UIViewController {
    public var viewModel: UserViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        loadData()
    }

    func loadData() {
        let parameters = RequestParameters.userData(email: UserDefaults.standard.string(forKey: StorageKeys.email) ?? "")
        showHUD()
        viewModel?.loadData(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let user):
                self?.hideHUD()
                print(user.data)
            case .failure(let error):
                self?.hideHUD()
                print(error.localizedDescription)
            }
        }
    }
}
