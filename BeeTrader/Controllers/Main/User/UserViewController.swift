//
//  UserViewController.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

public class UserViewController: UIViewController, UITextFieldDelegate {
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
        if let user = globalUser {
            loadData(email: user.email)
        }
    }

    func loadData(email: String) {
        let parameters = RequestParameters.userData(email: email)
        showHUD()
        avatar.alpha = 0.45
        viewModel?.loadData(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let user):
                self?.hideHUD()
                self?.setUpInfo(user.data)
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
            address.text = "\(user.address?.name ?? "---"), \(user.address?.postalCode ?? "---")"
            phoneNumber.text = user.phoneNumber ?? "---"
            if let imageUrl = user.image {
                UIView.animate(withDuration: 0.5, animations: {
                    self.avatar.alpha = 0
                 }, completion: nil)
                let url = URL(string: imageUrl)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async { [weak self] in
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.avatar.alpha = 1
                    }, completion: nil)
                    self?.avatar.image = UIImage(data: data!)
                }
            }
        }
    }

    @IBAction func onEditClicked(_: Any) {
        let storyboard = UIStoryboard(name: "UserDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetail)
        present(controller, animated: true)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
