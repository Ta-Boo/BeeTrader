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

class AddListingViewController: KeyboardLayoutManager {
    let viewModel = AddListingViewModel()
    var imagePicker: UIImagePickerController!

//    var imagePicker: UIImagePickerController!
    @IBOutlet var listingImage: UIImageView!
    @IBOutlet weak var listingTitle: UITextField!
    @IBOutlet weak var listingPrice: UITextField!
    @IBOutlet weak var listingDescription: UITextView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var parameters: [String: String?] {
        return RequestParameters.addListing(title: listingTitle.text,
                                            userId: GlobalUser.shared.user?.id,
                                            typeId: viewModel.category,
                                            description: listingDescription.text,
                                            price: Int(listingPrice.text!)!*100)
    }
    var isFormFilled: Bool {
           return listingTitle.isNotEmpty() && listingPrice.isNotEmpty() && viewModel.category != nil && viewModel.imageSet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        localize()
    }

    
    func localize() {
        changeImageButton.setTitle(L10n.Listing.Add.changeImage, for: .normal)
        listingTitle.placeholder = L10n.Listing.Add.title
        listingPrice.placeholder = L10n.Listing.Add.price
        categoryButton.setTitle(L10n.Listing.category, for: .normal)
        submitButton.setTitle(L10n.Common.submit, for: .normal)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    @IBAction func takePhoto(_: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentFailAlert(L10n.Alert.noCamera)
            return
        }
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func categoryTapped(_ sender: Any) {
        let controller = StoryboardScene.CategoryPicker.initialScene.instantiate()
        controller.viewModel.categoryPickCompletion = { [weak self] category in
            self?.viewModel.category = category.id
        }
        present(controller, animated: true)
    }
    
    @IBAction func submitActiontapped(_ sender: Any) {
        guard isFormFilled else {
            presentFailAlert(L10n.Alert.fill)
            return
        }
        viewModel.uploadListing(withParameters: parameters, image: listingImage.image)
    }
}
//MARK: Delegates


extension AddListingViewController: ImagePickerManager {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey: Any]) {
        viewModel.imageSet = true
        imagePicker.dismiss(animated: true)
        listingImage.image = image[.originalImage] as? UIImage
    }
}

protocol AddListingViewDelegate: Delegate {
    func listingChangedHandler()
}
extension AddListingViewController: AddListingViewDelegate {
    func listingChangedHandler() {
        dismiss(animated: true)
    }
}
