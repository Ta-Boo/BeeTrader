//
//  UserViewModel.swift
//  BeeTrader
//
//  Created by hladek on 08/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

protocol UserViewModelDelegate {
    func userLoaded(_ user: User)
    func userLoadFailure()
    func loadUser()
    func loadUserImage(_ image: String?)
}

class UserViewModel {
    
    var delegate: UserViewModelDelegate?
    
    func loadData(parameters: Parameters) {
        UrlRequest<User>().handle(ApiConstants.baseUrl + "api/userByEmail",
                                  methood: HTTPMethod.get,
                                  parameters: parameters) { [weak self] result in
//            completion(result)
                                    switch result {
                                    case .failure:
                                        self?.delegate?.userLoadFailure()
                                    case .success(let response):
                                        guard let user = response.data else {
                                            self?.delegate?.userLoadFailure()
                                            return
                                        }
                                        self?.delegate?.userLoaded(user)
                                    }
        }
    }
}
