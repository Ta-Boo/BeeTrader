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
    func updateViews(user: User)
    func completionHandler()
}


class UserDetailViewController: KeyboardLayoutManager {
    var viewModel = UserDetailViewModel()
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var address: UIButton!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet weak var changeAvatarLabel: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var parameters: WeakParameters {
        return RequestParameters.updateUser(firstName: firstName.text,
                                            lastName: lastName.text,
                                            addressID: viewModel.addressId,
                                            phoneNumber: phoneNumber.text,
                                            email: email.text,
                                            id: GlobalUser.shared.user?.id)
    }
    
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
            presentFailAlert(L10n.Alert.noCamera)
        }
    }

    @IBAction func sendTapped(_: Any) {
        viewModel.uploadData(withParameters: parameters ,image: viewModel.avatarToUpload(avatar))
    }

    @IBAction func onAddressTapped(_: Any) {
        let controller = StoryboardScene.AddressPicker.addressPickerViewController.instantiate()
        
        controller.addressPickCompletion = { [weak self] address in
            self?.address.setTitle("\(address.postalCode), \(address.name)", for: .normal)
            self?.viewModel.addressId = address.id
        }
        present(controller,animated: true)
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

    func completionHandler() {
        viewModel.userUpdateCompletion?(email.text ?? GlobalUser.shared.user?.email ?? "")
        dismiss(animated: false)
    }
    
    func updateViews(user: User) {
        firstName.text = user.firstName
        lastName.text = user.lastName
        address.setTitle("\(user.postalCode), \(user.city)", for: .normal)
        phoneNumber.text = user.phoneNumber ?? ""
        email.text = user.email
    }
}
