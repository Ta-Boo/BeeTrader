//
//  ListingDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation


class ListingDetailViewModel: ViewModel {
   
    var delegate: ListingDetailDelegate!
    var listingId: Int?
    var listing: ListingDetail?
    
    func viewModelDidLoad() {
        loadData()
    }
    
    func loadData() {
        guard let id = listingId else {
            delegate.presentFailure()
            return
        }
        delegate.showHUD()
        UrlRequest<ListingDetail>().handle(ApiConstants.listing,
                                           methood: HTTPMethod.get,
                                           parameters: RequestParameters.listing(id: id)) { [weak self] result in
            self?.delegate.hideHUD()
            switch result {
            case let .success(response):
                guard let data = response.data else {
                    self?.delegate.presentFailure()
                    return
                }
                self?.listing = data
                self?.delegate?.listingLoaded(listing: data)
            case .failure:
                self?.delegate.presentFailure()
            }
        }
    }
}
