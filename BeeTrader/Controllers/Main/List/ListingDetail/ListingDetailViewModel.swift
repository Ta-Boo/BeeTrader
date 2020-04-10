//
//  ListingDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

protocol ListingDetailDelegate {
    func loadListing()
    func listingLoadedSuccess(listing: ListingDetail)
    func listingLoadedFailure()
    func sendEmailHandler(sender: UITapGestureRecognizer)
    func setupViewsHandler()
}

class ListingDetailViewModel {
    var delegate: ListingDetailDelegate?
    var listingId: Int?
    var listing: ListingDetail?
    func loadData(parameters: Parameters) {
        UrlRequest<ListingDetail>().handle(ApiConstants.baseUrl + "listing",
                                           methood: HTTPMethod.get,
                                           parameters: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                guard let data = response.data else {
                    self?.delegate?.listingLoadedFailure()
                    return
                }
                self?.delegate?.listingLoadedSuccess(listing: data)
            case .failure:
                self?.delegate?.listingLoadedFailure()
            }
        }
    }
}
