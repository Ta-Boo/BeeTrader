//
//  ListingViewModel.swift
//  BeeTrader
//
//  Created by hladek on 16/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation
struct ListingData{
    var radius: Int?
    var page: Int = 1
    var categories: [Int]?
}

class ListingViewModel {
    let refreshControl = UIRefreshControl()
    var listings: [Listing] = []
    var listingData = ListingData()
//    var parameters = RequestParameters.listingInRadius(radius: 500, latitude: GlobalUser.shared?.latitude, longitude:  GlobalUser.shared?.longitude, page: 1)
    
    var parameters: Parameters  {
        get {
            return RequestParameters.listingInRadius(radius: listingData.radius, latitude: GlobalUser.shared?.latitude,
                                                     longitude: GlobalUser.shared?.longitude, page: listingData.page)
        }
    }
    
    func loadListings(parameters: Parameters, _ completion: @escaping (DataResult<[Listing]>) -> Void) {
        UrlRequest<[Listing]>().handle(ApiConstants.baseUrl + "api/listings/inRadius",
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { result in
            completion(result)
        }
    }
    
    func changeFilter(parameters: ListingData) {
        self.listingData.categories = parameters.categories
        self.listingData.radius = parameters.radius
    }
}
