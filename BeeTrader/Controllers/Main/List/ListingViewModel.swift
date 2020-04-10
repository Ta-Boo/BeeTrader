//
//  ListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 16/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

struct ListingData {
    var radius: Int?
    var page: Int = 1
    var categories: [Int]?
}

class ListingViewModel: ViewModel{
    
    var delegate: ListingViewDelegate?
    let refreshControl = UIRefreshControl()
    var listings: [Listing] = []
    var listingData = ListingData()

    var addListingController: UIViewController {
        let storyboard = UIStoryboard(name: "AddListing", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.addListing) as! AddListingViewController
        controller.viewModel.completionHandler = { [weak self] in
            self?.delegate?.showHUD()
            self?.loadListings { [weak self] in
                self?.delegate?.hideHUD()
            }
        }

        return controller
    }

    var filterListingController: ListingFilterViewController {
        let storyboard = UIStoryboard(name: "ListingFilter", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: ViewControllers.listingFilter) as! ListingFilterViewController
        controller.viewModel.submitCompletion = { [weak self] parameters in
            self?.changeFilter(parameters: parameters)
//            self?.delegate?.filterChangedHandler()
        }
        return controller
    }

    var parameters: Parameters {
        return RequestParameters.listingInRadius(radius: listingData.radius,
                                                 latitude: GlobalUser.shared?.latitude,
                                                 longitude: GlobalUser.shared?.longitude,
                                                 categories: listingData.categories,
                                                 page: listingData.page)
    }
    
    func viewModelDidLoad() {
        setupViews()
    }
    

    
    func setupViews() {
        delegate?.showHUD()
        loadListings { [weak self] in
            self?.delegate?.hideHUD()
        }
    }

    func loadListings(_ completionHandler: @escaping EmptyClosure) {
        UrlRequest<[Listing]>().handle(ApiConstants.baseUrl + "listings/inRadius",
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { [weak self] result in
            switch result {
            case .failure:
                self?.delegate?.presentFailure()
            case let .success(response):
                guard let listings = response.data else {
                    self?.delegate?.presentFailure()
                    return
                }
                self?.listings = listings
                self?.delegate?.showListings()
                completionHandler()
            }
        }
    }

    func changeFilter(parameters: ListingData) {
        listingData.categories = parameters.categories
        listingData.radius = parameters.radius
        delegate?.showHUD()
        loadListings { [weak self] in
            self?.delegate?.hideHUD()
        }
    }
}
