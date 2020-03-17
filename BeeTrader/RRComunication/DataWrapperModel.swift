//
//  DataWrapperModel.swift
//  BeeTrader
//
//  Created by hladek on 05/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

public struct DataWrapper<T: Codable>: Codable {
    let status: String
    let data: T?
    let errorCode: Int?

    enum CodingKeys: String, CodingKey {
        case status
        case data
        case errorCode = "error_code"
    }
}

public struct LoginResponse: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String?
    let city: String
    let postalCode: String
    let token: String
    
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

    }
}

public struct RegisterResponse: Codable {}
