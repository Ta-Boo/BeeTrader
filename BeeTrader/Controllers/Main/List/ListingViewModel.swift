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
    var text: String = ""
}

class ListingViewModel: ViewModel{
    
    var delegate: ListingViewDelegate?
    var listings: [Listing] = []
    var listingFilter = ListingFilter()
    var isLoading = false
    var endReached = false
    var longTapTimer : Date?
    var searchDebouncer: Debouncer?

    
    
    func onFilterChangedHandler(search: String?) {
        guard search != nil else { return }
        let debounceHandler: () -> Void = { [weak self] in
            self?.listingFilter.text = search ?? ""
            self?.resetData()
            self?.loadListings()
            
        }
        guard let searchDebouncer = searchDebouncer else {
            let debouncer = Debouncer(handler: {})
            self.searchDebouncer = debouncer
            onFilterChangedHandler(search: search)
            return
        }

        searchDebouncer.invalidate()
        searchDebouncer.handler = debounceHandler
        searchDebouncer.call()
    }



    var parameters: Parameters {
        return RequestParameters.listings(radius: listingFilter.radius,
                                          latitude: GlobalUser.shared.user?.latitude,
                                          longitude: GlobalUser.shared.user?.longitude,
                                          categories: listingFilter.categories,
                                          page: listingFilter.page,
                                          text: listingFilter.text)
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
    func shouldLoad() -> Bool {
        return !isLoading && !endReached
    }

    func loadListings(_ completionHandler: EmptyClosure? = nil) {
        if !shouldLoad() { return }
        isLoading = true
        delegate?.showHUD()
        UrlRequest<[Listing]>().handle(ApiConstants.listings ,
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
                if listings.count < 8 {
                    self?.endReached = true
                }
                self?.listings += listings
                let indexpath = ((self!.listings.count  - listings.count)..<self!.listings.count).map{ IndexPath(item: $0, section: 0) }
                self?.delegate?.showListings(at: indexpath)
                completionHandler?()
            }
        self?.delegate?.hideHUD()
        self?.isLoading = false
        }
    }
    
    func loadMoreListings(_ completion: EmptyClosure? = nil) {
        if !shouldLoad() { return }
        listingFilter.page += 1
        loadListings {
            completion?()
        }
    }
    
    func resetData() {
        listings.removeAll()
        endReached = false
        listingFilter.page = 1
    }
    

    func changeFilter(parameters: ListingFilter) {
        listingFilter.categories = parameters.categories
        listingFilter.radius = parameters.radius
        resetData()
        delegate?.showHUD()
        loadListings { [weak self] in
            self?.delegate?.hideHUD()
        }
    }
}
