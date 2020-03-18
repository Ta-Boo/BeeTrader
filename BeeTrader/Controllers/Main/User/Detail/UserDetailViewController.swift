//
//  UserDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class UserDetailViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var avatar: UIImageView!
    
    
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
}
