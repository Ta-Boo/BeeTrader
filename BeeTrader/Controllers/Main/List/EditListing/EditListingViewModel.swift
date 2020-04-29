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
    var delegate: EditListingViewDelegate?
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
                self?.delegate?.fillFields(listing: data)
            case .failure:
                self?.delegate?.presentFailure()
            }
        }
    }
    
    func updateListing(image: UIImage?) {
        guard let delegate = delegate else {
            return
        }
        if !delegate.isFilled {
            delegate.presentFailAlert(L10n.Alert.fill)
            return
        }
        let url = ApiConstants.updateListing
        let images = [Image(name: "image", fileName: "image", data: image!)]
        delegate.changeAccessibility(to: false)
        delegate.showHUD()

        UrlRequest<Dump>().uploadImages(url: url, images: images, parameters: delegate.parameters, loadingProgressor: { _ in
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
    
    func deleteListing() {
        let parameters = RequestParameters.listing(id: listingId)
        let url = ApiConstants.listing
        delegate?.changeAccessibility(to: false)
        delegate?.showHUD()
        UrlRequest<Dump>().handle(url, methood: .delete, parameters: parameters) { [weak self] response in
            switch response {
            case .success:
                self?.delegate?.dismiss(animated: true, completion: nil)
                self?.completionHandler?()
            case .failure:
                self?.delegate?.presentFailure()
            }
            self?.delegate?.hideHUD()
            self?.delegate?.changeAccessibility(to: true)
        }
    }
   

    
}
