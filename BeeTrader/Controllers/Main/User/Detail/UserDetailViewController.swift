//
//  UserDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias ImagePickerKeyboardManager = UITableViewController & UITextFieldDelegate & UINavigationControllerDelegate & UIImagePickerControllerDelegate
class UserDetailViewController: ImagePickerKeyboardManager {

    var viewModel = UserDetailViewModel()
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        guard let globalUser = GlobalUser.shared else  {
            presentFailAlert()
            return
        }
        firstName.text = globalUser.firstName
        lastName.text = globalUser.lastName
        address.setTitle( "\(globalUser.postalCode), \(globalUser.city)", for: .normal)
        phoneNumber.text = globalUser.phoneNumber ?? ""
        email.text = globalUser.email
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            viewModel.imagePicker =  UIImagePickerController()
            viewModel.imagePicker.delegate = self
            viewModel.imagePicker.sourceType = .camera
            present(viewModel.imagePicker, animated: true, completion: nil)
        } else {
            presentFailAlert(title: "No camera detected")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey : Any]) {
        viewModel.imagePicker.dismiss(animated: true, completion: nil)
        viewModel.avatarChanged = true
        avatar.image = image[.originalImage] as? UIImage
    }
        
    @IBAction func sendTapped(_ sender: Any) {
        let parameters = RequestParameters.updateUser(firstName: firstName.text,
                                                      lastName: lastName.text,
                                                      addressID: viewModel.addressId,
                                                      phoneNumber: phoneNumber.text,
                                                      email: email.text,
                                                      id: GlobalUser.shared?.id)
        
        viewModel.uploadData(image: viewModel.avatarToUpload(avatar), parameters: parameters, successCompletionHandler: { [weak self] in
            self?.viewModel.userUpdateCompletion?(self?.email.text ?? GlobalUser.shared?.email ?? "")
            self?.dismiss(animated: false)
        }, failureCompletionHandler: { [weak self] in
            self?.presentFailedRequestAlert()
        })
    }
    
    @IBAction func onAddressTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddressPicker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetailAddressPicker) as! AddressPickerViewController
        controller.addressPickCompletion =  { [weak self] address in
            self?.address.setTitle("\(address.postalCode), \(address.name)", for: .normal)
            self?.viewModel.addressId = address.id
        }
        present(controller, animated: true)
    }
}
