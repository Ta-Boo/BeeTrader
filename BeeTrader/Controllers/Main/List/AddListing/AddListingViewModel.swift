//
//  AddListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 23/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AddListingViewModel: ViewModel {
    var delegate: AddListingViewDelegate?
    var imagePicker: UIImagePickerController!
    var category: Int?
    var imageSet: Bool = false
    
    var completionHandler: EmptyClosure?

    
    func viewModelDidLoad() {}
    
    func uploadListing(image: UIImage?) {
        guard let delegate = delegate else {
            return
        }
        if !delegate.isFilled {
            delegate.presentFailAlert("Fill all fields and upload image!")
            return
        }
        let url = "\(ApiConstants.baseUrl)listing"
        let images = [Image(name: "image", fileName: "image", data: image!)]

        UrlRequest<UploadResponse>().uploadImages(url: url, images: images, parameters: delegate.parameters, loadingProgressor: { _ in
        }, successCompletion: { [weak self] in
            self?.delegate?.dismiss(animated: true, completion: nil)
            self?.completionHandler?()
        }, failureCompletion: { [weak self] in
            self?.delegate?.presentFailure()
        })
    }
    
    func takePhoto() {
        if let delegate = delegate, UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera
            delegate.presentController(imagePicker)
        } else {
            delegate?.presentFailAlert("No camera detected")
        }
    }
    
    func handlePhotoChanged() {
        imageSet = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func categoryTappedHandle() {
        let storyboard = UIStoryboard.init(name: "CategoryPicker", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as! CategoryPickerViewController
        controller.viewModel.categoryPickCompletion = { [weak self] category in
            self?.category = category.id
        }
        delegate?.presentController(controller)
    }
}
