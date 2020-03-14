//
//  Parameters+Headers.swift
//  BeeTrader
//
//  Created by hladek on 12/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

public struct RequestParameters {
    static func login(withEmail email: String, password: String) -> Parameters {
        return ["email": email, "password": password]
    }

    static func register(firstName: String, lastName: String,
                         email: String, password: String) -> Parameters {
        return ["first_name": firstName, "last_name": lastName, "email": email,
                "password": password, "password_confirmation": password]
    }

    static func userData(email: String) -> Parameters {
        return ["email": email]
    }
}
