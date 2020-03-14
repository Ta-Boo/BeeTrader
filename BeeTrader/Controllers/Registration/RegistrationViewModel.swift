//
//  RegistrationViewModel.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

public class RegistrationViewModel {
    func login(parameters: Parameters, _ completion: @escaping (DataResult<LoginResponse>) -> Void) {
        UrlRequest<LoginResponse>().handle(ApiConstants.baseUrl + "api/login",
                                           methood: HTTPMethod.post,
                                           parameters: parameters) { result in
            completion(result)
        }
    }

    func register(parameters: Parameters, _ completion: @escaping (DataResult<RegisterResponse>) -> Void) {
        UrlRequest<RegisterResponse>().handle(ApiConstants.baseUrl + "api/register",
                                              methood: HTTPMethod.post,
                                              parameters: parameters) { result in
            completion(result)
        }
    }
}
