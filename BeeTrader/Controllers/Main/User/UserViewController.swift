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
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var editButton: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        if let user = GlobalUser.shared {
            loadData(email: user.email)
        }
    }

    func loadData(email: String) {
        let parameters = RequestParameters.userData(email: email)
        showHUD()
        viewModel?.loadData(parameters: parameters) { [weak self] result in
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
        controller.userUpdateCompletion = { [weak self] email in
            self?.loadData(email: email)
        }
        present(controller, animated: true)
    }
}
