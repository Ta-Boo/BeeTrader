//
//  EditListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 25/04/2020.
//  Copyright © 2020 hladek. All rights reserved.
//


import Foundation
import UIKit
import Alamofire

class EditListingViewModel: ViewModel {
    var delegate: EditListingViewDelegate!
    var listingId: Int!
    var completionHandler: EmptyClosure?
    var category: Int?

    func viewModelDidLoad() {
        loadData()
    }
    
    func loadData() {
        let parameters = RequestParameters.listing(id: listingId)
        delegate?.showHUD()
        UrlRequest<ListingDetail>().handle(ApiConstants.listing,
                                            methood: HTTPMethod.get,
                                            parameters: parameters) { [weak self] result in
            self?.delegate?.hideHUD()
            switch result {
            case let .success(response):
                guard let data = response.data else {
                    self?.delegate?.presentFailure()
                    return
                }
                self?.category = data.category
                self?.delegate.listingLoadedHandler(listing: data)
                
            case .failure:
                self?.delegate?.presentFailure()
            }
        }
    }
    
    func updateListing(withParameters parameters: WeakParameters, image: UIImage?) {
        let url = ApiConstants.updateListing
        let images = [Image(name: "image", fileName: "image", data: image!)]
        delegate.changeAccessibility(to: false)
        delegate.showHUD()

        UrlRequest<Dump>().uploadImages(url: url, images: images,
                                        parameters: parameters)
                                       { [weak self] result in
            self?.delegate.hideHUD()
            self?.delegate.changeAccessibility(to: true)
            switch result {
            case .success:
                self?.completionHandler?()
                self?.delegate.listingEditOKHandler()
            case .failure:
                self?.delegate.presentFailure()
            }
            
        }
    }
    
    func deleteListing() {
        let url = ApiConstants.listing
        delegate?.changeAccessibility(to: false)
        delegate?.showHUD()
        UrlRequest<Dump>().handle(url, methood: .delete,
                                  parameters: RequestParameters.listing(id: listingId)) { [weak self] response in
            self?.delegate?.hideHUD()
            self?.delegate?.changeAccessibility(to: true)
            switch response {
            case .success:
                self?.delegate.listingEditOKHandler()
                self?.completionHandler?()
            case .failure:
                self?.delegate?.presentFailure()
            }
        }
    }
}
