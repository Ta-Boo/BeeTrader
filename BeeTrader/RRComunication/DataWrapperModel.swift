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

public struct RegisterResponse: Codable {}
public struct UploadResponse: Codable {}
