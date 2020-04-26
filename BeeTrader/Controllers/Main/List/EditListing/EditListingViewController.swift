//
//  EditListingViewController.swift
//  BeeTrader
//
//  Created by hladek on 25/04/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

protocol EditListingViewDelegate: Delegate {
    var parameters: [String: String?] { get }
    var isFilled: Bool { get }
    func fillFields(listing: ListingDetail)
    func changeAccessibility(to: Bool)
    func dismiss(animated : Bool, completion: EmptyClosure?)

}

class EditListingViewController: KeyboardLayoutManager {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var changeButton: UIButton!
    
    var imagePicker: UIImagePickerController!

    
    let viewModel = EditListingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
    }
    
    func localize() {
           changeButton.setTitle(L10n.Listing.Add.changeImage, for: .normal)
           titleLabel.placeholder = L10n.Listing.Add.title
           priceLabel.placeholder = L10n.Listing.Add.price
       }
    
    @IBAction func submitTapped(_ sender: Any) {
        viewModel.updateListing(image: image.image)
    }
    @IBAction func changeImageTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   imagePicker = UIImagePickerController()
                   imagePicker.delegate = self
                   imagePicker.sourceType = .camera
                   present(imagePicker, animated: true)
               } else {
                   presentFailAlert(L10n.Alert.noCamera)
               }
    }
    @IBAction func categoryTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CategoryPicker", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! CategoryPickerViewController
        controller.viewModel.categoryPickCompletion = { [weak self] category in
            self?.viewModel.category = category.id
               }
        present(controller, animated: true)
    }
    @IBAction func deleteTapped(_ sender: Any) {
        presentConfirmationAlert(title: L10n.Listing.Edit.removeDialogTitle) { [weak self] in
            self?.viewModel.deleteListing()
        }
    }
}
//MARK: Delegates
extension EditListingViewController: ImagePickerManager {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo image: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true)
        self.image.image = image[.originalImage] as? UIImage
    }
}

extension EditListingViewController: EditListingViewDelegate{
    var isFilled: Bool {
        return titleLabel.isNotEmpty() && priceLabel.isNotEmpty() && viewModel.category != nil
    }
    
    var parameters: [String: String?] {
        return RequestParameters.updateListing(listingId: viewModel.listingId, title: titleLabel.text, typeId: viewModel.category, description: descriptionTextView.text, price: Int(priceLabel.text!)!*100)
    }
    
    func fillFields(listing: ListingDetail) {
        if let listingImage = listing.image {
            image.imageFromUrl("\(ApiConstants.baseUrl)\(listingImage)", useCached: true, true)
        }
        titleLabel.text = listing.title
        priceLabel.text = "\(listing.price/100)"
        descriptionTextView.text = listing.description
    }
    
    func changeAccessibility(to: Bool) {
           view.isUserInteractionEnabled = to
    }
}
