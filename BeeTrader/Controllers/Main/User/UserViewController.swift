//
//  UserViewController.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    var viewModel = UserViewModel()
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var editButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        guard let email = GlobalUser.shared?.email else{
            presentFailAlert(title: "Something went wrong")
            return
        }
        let parameters = RequestParameters.userData(email: email)
        showHUD()
        viewModel.loadData(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let user):
                self?.setUpInfo(user.data)
                GlobalUser.update(user.data)
                self?.hideHUD()
                
            case .failure:
                self?.hideHUD()
            }
        }
    }

    func setUpInfo(_ user: User?) {
        if let user = user {
            firstName.text = user.firstName
            lastName.text = user.lastName
            email.text = user.email
            address.text = "\(user.city ), \(user.postalCode)"
            phoneNumber.text = user.phoneNumber ?? "---"
            if let imageUrl = user.image {
                avatar.loadImage(url: "\(ApiConstants.baseUrl)\(imageUrl)", true)
            }
        }
    }

    @IBAction func onEditClicked(_: Any) {
        let storyboard = UIStoryboard(name: "UserDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetail) as! UserDetailViewController
        controller.viewModel.userUpdateCompletion = { [weak self] email in
            self?.loadData()
        }
        present(controller, animated: true)
    }
}
