//
//  UserData.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

public struct Address: Codable {
    let id: Int
    let name: String
    let postalCode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case postalCode = "postal_code"
    }
    
}

public struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let image: String?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case image
        case address
    }
}
