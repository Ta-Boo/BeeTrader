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


class UserDetailViewController: UINavigationController, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var viewMModel = UserDetailViewModel()
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    func setupData() {
        firstName.text = globalUser?.firstName ?? ""
        lastName.text = globalUser?.lastName ?? ""
        address.text = globalUser?.postalCode ?? ""
        phoneNumber.text = globalUser?.firstName ?? ""
        email.text = globalUser?.email ?? ""
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        avatar.image = image[.originalImage] as? UIImage
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddressPicker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetailAddressPicker)
        let nieco = self.navigationController
        present(controller, animated: true)
//        let parameters = RequestParameters.updateUser(firstName: firstName.text ?? "Missing", lastName: lastName.text ?? "Missing", addressID: 77, phoneNumber: phoneNumber.text ?? "Missing", email: email.text!)
//        viewMModel.uploadData(image: avatar.image!, parameters: parameters)
    }
}
