//
//  UserDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//
import Alamofire
import Foundation

class UserDetailViewModel: ViewModel {
    var addressId: Int?
    var avatarChanged = false
    var userUpdateCompletion: StringClosure?
    var imagePicker: UIImagePickerController!
    var delegate: UserDetailViewDelegate?

    func viewModelDidLoad() {
        setupViews()
    }

    func setupViews() {
        guard let globalUser = GlobalUser.shared else {
            delegate?.presentFailure()
            return
        }
        delegate?.setupViews(user: globalUser)
    }

    func handleChangedPhoto() {
        imagePicker.dismiss(animated: true, completion: nil)
        avatarChanged = true
    }

    func handleAddressTapped() {
        let storyboard = UIStoryboard(name: "AddressPicker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetailAddressPicker) as! AddressPickerViewController
        controller.addressPickCompletion = { [weak self] address in
            self?.delegate?.addressPickerCompletionHandler(address: address)
        }
        delegate?.presentController(controller)
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

    func uploadData(image: UIImage?) {
        let url = "\(ApiConstants.baseUrl)user"
        var images: [Image]
        if let img = image {
            images = [Image(name: "image", fileName: "image", data: img)]
        } else {
            images = []
        }

        UrlRequest<UploadResponse>().uploadImages(url: url, images: images, parameters: delegate?.parameters, loadingProgressor: { _ in
        }, successCompletion: { [weak self] in
            self?.delegate?.completionHandler()
        }, failureCompletion: { [weak self] in
            self?.delegate?.presentFailure()
        })
    }

    func avatarToUpload(_ imageView: UIImageView) -> UIImage? {
        if avatarChanged {
            return imageView.image
        } else {
            return nil
        }
    }
}
