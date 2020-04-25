//
//  UserDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

protocol UserDetailViewDelegate: Delegate {
    var parameters: [String: String?] { get }
    func setupViews(user: User)
    func presentController(_ controller: UIViewController)
    func addressPickerCompletionHandler(address: Address)
    func completionHandler()
}


class UserDetailViewController: ImagePickerKeyboardManager {
    var viewModel = UserDetailViewModel()
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var address: UIButton!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet weak var changeAvatarLabel: UIButton!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        localize()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func localize() {
        changeAvatarLabel.setTitle(L10n.User.changeAvatar, for: .normal)
    }

    @IBAction func takePhoto(_: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker,animated: true)
        } else {
            presentFailAlert("No camera detected")
        }
    }

    @IBAction func sendTapped(_: Any) {
        viewModel.uploadData(image: viewModel.avatarToUpload(avatar))
    }

    @IBAction func onAddressTapped(_: Any) {
        viewModel.handleAddressTapped()
    }
}
//MARK: Delegates (ImagePickerManager)

extension UserDetailViewController: ImagePickerManager {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey: Any]) {
        avatar.image = image[.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        viewModel.avatarChanged = true
    }
}

//MARK: Delegates (UserDetailViewDelegate)

extension UserDetailViewController: UserDetailViewDelegate {
    var parameters: [String: String?] {
        return RequestParameters.updateUser(firstName: firstName.text,
                                            lastName: lastName.text,
                                            addressID: viewModel.addressId,
                                            phoneNumber: phoneNumber.text,
                                            email: email.text,
                                            id: GlobalUser.shared.user?.id)
    }

    func completionHandler() {
        viewModel.userUpdateCompletion?(email.text ?? GlobalUser.shared.user?.email ?? "")
        dismiss(animated: false)
    }

    func addressPickerCompletionHandler(address: Address) {
        self.address.setTitle("\(address.postalCode), \(address.name)", for: .normal)
        viewModel.addressId = address.id
    }

    func presentController(_ controller: UIViewController) {
        present(controller, animated: true)
    }


    func setupViews(user: User) {
        firstName.text = user.firstName
        lastName.text = user.lastName
        address.setTitle("\(user.postalCode), \(user.city)", for: .normal)
        phoneNumber.text = user.phoneNumber ?? ""
        email.text = user.email
    }
}
