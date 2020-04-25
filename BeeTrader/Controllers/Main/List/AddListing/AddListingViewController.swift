//
//  AddListingViewController.swift
//  BeeTrader
//
//  Created by hladek on 23/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol AddListingViewDelegate: Delegate {
    var parameters: [String: String?] { get }
    var isFilled: Bool { get }
    func changeAccessibility(to: Bool)
    func dismiss(animated : Bool, completion: EmptyClosure?)
}

class AddListingViewController: ImagePickerKeyboardManager {
    let viewModel = AddListingViewModel()
    var imagePicker: UIImagePickerController!

//    var imagePicker: UIImagePickerController!
    @IBOutlet var listingImage: UIImageView!
    @IBOutlet weak var listingTitle: UITextField!
    @IBOutlet weak var listingPrice: UITextField!
    @IBOutlet weak var listingDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey: Any]) {
        viewModel.imageSet = true
        imagePicker.dismiss(animated: true)
        listingImage.image = image[.originalImage] as? UIImage
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    @IBAction func takePhoto(_: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true)
        } else {
            presentFailAlert("No camera detected")
        }    }
    
    @IBAction func categoryTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CategoryPicker", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! CategoryPickerViewController
        controller.viewModel.categoryPickCompletion = { [weak self] category in
            self?.viewModel.category = category.id
               }
        present(controller, animated: true)
    }
    
    @IBAction func submitActiontapped(_ sender: Any) {
        viewModel.uploadListing(image: listingImage.image)
    }
}

extension AddListingViewController: AddListingViewDelegate {
    var isFilled: Bool {
        return listingTitle.isNotEmpty() && listingPrice.isNotEmpty() && viewModel.category != nil && viewModel.imageSet
    }
    
    func changeAccessibility(to: Bool) {
        view.isUserInteractionEnabled = to
    }
    
    
    var parameters: [String: String?] {
        return RequestParameters.addListing(title: listingTitle.text, userId: GlobalUser.shared.user?.id, typeId: viewModel.category, description: listingDescription.text, price: Int(listingPrice.text!)!*100)
    }
    
}
