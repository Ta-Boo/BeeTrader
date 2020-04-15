//
//  ListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 16/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

struct ListingFilter {
    var radius: Int?
    var page: Int = 1
    var categories: [Int]?
}

class ListingViewModel: ViewModel{
    
    var delegate: ListingViewDelegate?
    let refreshControl = UIRefreshControl()
    var listings: [Listing] = []
    var listingFilter = ListingFilter()
    var isLoading = false

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
        }
        return controller
    }

    var parameters: Parameters {
        return RequestParameters.listingInRadius(radius: listingFilter.radius,
                                                 latitude: GlobalUser.shared?.latitude,
                                                 longitude: GlobalUser.shared?.longitude,
                                                 categories: listingFilter.categories,
                                                 page: listingFilter.page)
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
        isLoading = true
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
        self?.isLoading = false
        }
    }
    
    
    func requestListings() {
        
    }

    func changeFilter(parameters: ListingFilter) {
        listingFilter.categories = parameters.categories
        listingFilter.radius = parameters.radius
        delegate?.showHUD()
        loadListings { [weak self] in
            self?.delegate?.hideHUD()
        }
    }
}
