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
    var delegate: AddListingViewDelegate!
    var category: Int?
    var imageSet: Bool = false
    var completionHandler: EmptyClosure?

    func viewModelDidLoad() {}
    
    func uploadListing(withParameters parameters: WeakParameters,image: UIImage?) {
        let url = ApiConstants.listing
        let images = [Image(name: "image", fileName: "image", data: image!)]
        delegate.changeAccessibility(to: false)
        delegate.showHUD()

        UrlRequest<Dump>().uploadImages(url: url, images: images, parameters: parameters){ [weak self]  result in
            self?.delegate?.hideHUD()
            self?.delegate?.changeAccessibility(to: true)
            switch result{
            case .success:
                self?.delegate.listingChangedHandler()
                self?.completionHandler?()
            case .failure:
                self?.delegate?.presentFailure()
            }
        }
    }
    
}
