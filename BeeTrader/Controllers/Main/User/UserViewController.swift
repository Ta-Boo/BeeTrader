//
//  UserViewController.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
        viewModel.delegate = self
        loadUser()
    }

    func setUpInfo(_ user: User?) {
        if let user = user {
            firstName.text = user.firstName
            lastName.text = user.lastName
            email.text = user.email
            address.text = "\(user.city ), \(user.postalCode)"
            phoneNumber.text = user.phoneNumber ?? "---"
            loadUserImage(user.image)
        }
    }

    @IBAction func onEditClicked(_: Any) {
        let storyboard = UIStoryboard(name: "UserDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetail) as! UserDetailViewController
        controller.viewModel.userUpdateCompletion = { [weak self] email in
            self?.loadUser()
        }
        present(controller, animated: true)
    }
}

extension UserViewController: UserViewModelDelegate {
    func loadUserImage(_ image: String?) {
        if let imageUrl = image {
            avatar.loadImage(url: "\(ApiConstants.baseUrl)\(imageUrl)", true)
        }
    }
    
    func userLoaded(_ user: User) {
        setUpInfo(user)
        GlobalUser.update(user)
        hideHUD()
    }
    
    func userLoadFailure() {
        presentFailedRequestAlert()
        hideHUD()
    }
    
    func loadUser() {
        guard let email = GlobalUser.shared?.email else{
            presentFailAlert(title: "Something went wrong")
            return
        }
        let parameters = RequestParameters.userData(email: email)
        showHUD()
        viewModel.loadData(parameters: parameters)
    }
    
}
