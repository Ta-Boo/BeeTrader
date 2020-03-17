//
//  ListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 16/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

class ListingViewModel {
    func loadListings(parameters: Parameters, _ completion: @escaping (DataResult<[Listing]>) -> Void) {
        UrlRequest<[Listing]>().handle(ApiConstants.baseUrl + "api/listings/inRadius",
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { result in
            completion(result)
        }
    }
}
