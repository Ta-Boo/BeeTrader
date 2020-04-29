//
//  ListingFilterViewModel.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

class ListingFilterViewModel: ViewModel {
    var delegate: ListingFilterViewDelegate?
    var submitCompletion: ((ListingFilter) -> Void)?
    var filterTypes: [Category]? = []
    
    func viewModelDidLoad() {
        loadCategories()
    }

    func loadCategories() {
        delegate?.showHUD()
        UrlRequest<[Category]>().handle(ApiConstants.categories,
                                        methood: HTTPMethod.get) { [weak self] result in
                                            self?.delegate?.hideHUD()
                                            switch result {
                                            case .failure:
                                                self?.delegate?.presentFailure()
                                            case .success(let response):
                                                guard let categories = response.data else {
                                                    self?.delegate?.presentFailure()
                                                    return
                                                }
                                                self?.filterTypes = categories
                                                self?.delegate?.showCategories()
                                            }
        }
    }
    func handleSubmit(distance: Int) {
        let categories = filterTypes?.filter { $0.isChoosen ?? false }.map { $0.id }
        let filterData = ListingFilter(radius: distance, categories: categories)
        submitCompletion?(filterData)
    }
    
    
}
