import Alamofire
import Foundation
import UIKit

protocol Delegate {
    func showHUD()
    func hideHUD()
    func presentFailure()
    func presentFailAlert(_ title: String)
}

extension Delegate where Self: UIViewController {
    func presentFailure() {
        presentFailedRequestAlert()
    }

    func presentFailAlert(_ title: String) {
        presentFailAlert(title: title)
    }
}

protocol UserViewDelegate: Delegate {
    func showUserInfo(_ user: User)
    func presetnEditController(_ controller: UIViewController)
}

class UserViewController: UIViewController {
    let viewModel = UserViewModel()

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
        viewModel.viewModelDidLoad()
    }

    @IBAction func onEditClicked(_: Any) {
        viewModel.handleEditController()
    }
    
    @objc func logOutTapped(_ sender: UIBarButtonItem) {
        (tabBarController as! MainTabBarController).handleLogOut?()
    }
}

extension UserViewController: UserViewDelegate {
    func presetnEditController(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func presentFailure() {
        presentFailedRequestAlert()
    }

    func showUserInfo(_ user: User) {
        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = user.email
        address.text = "\(user.city), \(user.postalCode)"
        phoneNumber.text = user.phoneNumber ?? "---"
        if let imageUrl = user.image {
            avatar.imageFromUrl(ApiConstants.getImage(postFix: imageUrl), useCached: false, true)
        }
    }
}
