//
//  Request.swift
//  BeeTrader
//
//  Created by hladek on 05/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

typealias DataResult<Type: Codable> = Result<DataWrapper<Type>>
enum ApiConstants {
//    static let baseUrl = "http://localhost:8000/"
    static let baseUrl = "http://192.168.0.100:8000/"
}

class UrlRequest<WrappedData: Codable> {
    func handle(_ url: String,
                methood: HTTPMethod,
                parameters: Parameters? = nil,
                encoding: ParameterEncoding = URLEncoding.queryString,
                headers _: HTTPHeaders? = nil,
                completionHandler: @escaping (DataResult<WrappedData>) -> Void) {
        Alamofire.request(
            url,
            method: methood,
            parameters: parameters,
            encoding: encoding
        ).validate().responseJSON { response in
            print(response)
            let result = Result<DataWrapper<WrappedData>>(value: {
                try JSONDecoder().decode(DataWrapper<WrappedData>.self, from: response.data!)
            })
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data.data)
            }
            print(result)
            completionHandler(result)
        }
    }
}
