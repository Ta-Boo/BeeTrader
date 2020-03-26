//
//  Parameters+Headers.swift
//  BeeTrader
//
//  Created by hladek on 12/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

struct RequestParameters {
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
    static func listingInRadius(radius: Int?, latitude: Double?,
                                longitude: Double?, categories: [Int]? = [],
                                page: Int ) -> Parameters {
        let finalRadius = radius ?? 10000
        let finalLatitude = latitude ?? 50.0
        let finalLongitude = longitude ?? 20.0
        let finalCategories = categories ?? []
        
        return ["radius": finalRadius,
                "lat": finalLatitude,
                "lon": finalLongitude,
                "categories": finalCategories ]
    }
    
    static func listing(id: Int) -> Parameters {
        return ["id": id]
    }
    
    static func updateUser(firstName: String?, lastName: String?,
                           addressID: Int?, phoneNumber: String?, email: String?, id: Int?) -> Dictionary<String,String?> {
        return ["first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "email": email,
                "address_id": addressID.optionalString(),
                "id": id.optionalString()]
    }
    static func addresses(filter: String) -> Parameters {
        return ["filter": filter]
    }
}

extension Optional where Wrapped == Int {
    func optionalString() -> String? {
        guard let value = self else {
            return nil
        }
        return String(value)
    }
}
