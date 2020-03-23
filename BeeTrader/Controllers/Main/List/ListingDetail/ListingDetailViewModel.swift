//
//  ListingDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import Alamofire

class ListingDetailViewModel {
    var listingId: Int?
    var listing: ListingDetail?
    func loadData(parameters: Parameters, _ completion: @escaping (DataResult<ListingDetail>) -> Void) {
        UrlRequest<ListingDetail>().handle(ApiConstants.baseUrl + "api/listing",
                                  methood: HTTPMethod.get,
                                  parameters: parameters) { result in
            completion(result)
        }
    }
    
}
