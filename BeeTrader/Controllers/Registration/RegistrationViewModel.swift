//
//  RegistrationViewModel.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation


class RegistrationViewModel: ViewModel {
    
    var delegate: SignInDelegate!
    var okLoginHandler: EmptyClosure?
    
    func login() {
        delegate.showHUD()
        UrlRequest<User>().handle(ApiConstants.baseUrl + "login",
                                  methood: HTTPMethod.post,
                                  parameters: delegate.loginParameters) {  [weak self] response in
                                    switch response {
                                    case .success(let result):
                                        guard let data = result.data else {
                                            self?.delegate.presentFailure()
                                            return
                                        }
                                        self?.saveUserData(user: data)
                                        self?.okLoginHandler!()
                                    case.failure:
                                        self?.delegate.presentFailure()
                                    }
                                    self?.delegate.hideHUD()
        }
    }

    func viewModelDidLoad() {
        
    }
    func register(withParameters parameters: Parameters) {
        delegate.showHUD()
        UrlRequest<RegisterResponse>().handle(ApiConstants.baseUrl + "register",
                                              methood: HTTPMethod.post,
                                              parameters: parameters) { [weak self] response in
                                                switch response {
                                                case .success(let result):
                                                    guard let data = result.data else {
                                                        self?.delegate.presentFailure()
                                                        return
                                                    }
                                                    self?.delegate.okRegistrationHandler(user: data)
                                                case.failure:
                                                    self?.delegate.presentFailure()
                                                }
                                                self?.delegate.hideHUD()
        }
    }
    func saveUserData(user: User) {
        GlobalUser.shared.update(user)
    }


}
