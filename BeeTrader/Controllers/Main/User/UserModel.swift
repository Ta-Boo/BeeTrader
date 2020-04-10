//
//  UserData.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String?
    let city: String
    let postalCode: String
    let token: String?
    let image: String?
    let id: Int

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case latitude
        case longitude
        case phoneNumber = "phone_number"
        case city = "name"
        case postalCode = "postal_code"
        case token
        case image
        case id
    }
}
