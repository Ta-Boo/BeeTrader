//
//  ListingFilterViewModel.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

class ListingFilterViewModel {
    var submitCompletion: ((ListingData) -> Void)?
    var filterTypes: [Category]? = []

    func loadCategories(_ completion: @escaping (DataResult<[Category]>) -> Void) {
        UrlRequest<[Category]>().handle(ApiConstants.baseUrl + "api/categories",
                                       methood: HTTPMethod.get) { result in
            completion(result)
        }
    }
}
