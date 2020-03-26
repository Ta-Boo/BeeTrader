//
//  AddressPickerViewModel.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import Alamofire

class AddressPickerViewModel {
    var addresses: [Address] = []
    var searchDebouncer: Debouncer?

    func loadAddresses(parameters: Parameters, _ completion: @escaping (DataResult<[Address]>) -> Void) {
        UrlRequest<[Address]>().handle(ApiConstants.baseUrl + "api/addresses",
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { result in
            completion(result)
        }
    }
}
