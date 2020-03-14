//
//  UserViewModel.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

public class UserViewModel {
    func loadData(parameters : Parameters, _ completion : @escaping (DataResult<User>) -> Void) {
        UrlRequest<User>().handle(ApiConstants.baseUrl + "api/userByEmail",
                                           methood: HTTPMethod.get,
                                           parameters: parameters) { result in
            completion(result)
        }
    }
}
