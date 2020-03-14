//
//  DataWrapperModel.swift
//  BeeTrader
//
//  Created by hladek on 05/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

enum ApiConstants {
    static let baseUrl = "http://localhost:8000/"
}

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

// public struct ErrorResponse: Decodable{
//    let error
// }

public struct LoginResponse: Codable {
    let token: String
    let email: String
}

public struct RegisterResponse: Codable {}
