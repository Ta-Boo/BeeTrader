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
        delegate.changeAccessibility(to: false)
        delegate.showHUD()

        UrlRequest<UploadResponse>().uploadImages(url: url, images: images, parameters: delegate.parameters, loadingProgressor: { _ in
        }, successCompletion: { [weak self] in
            self?.delegate?.dismiss(animated: true, completion: nil)
            self?.completionHandler?()
            self?.delegate?.hideHUD()
        }, failureCompletion: { [weak self] in
            self?.delegate?.presentFailure()
            self?.delegate?.changeAccessibility(to: true)
            self?.delegate?.hideHUD()
        })
    }
    
}
