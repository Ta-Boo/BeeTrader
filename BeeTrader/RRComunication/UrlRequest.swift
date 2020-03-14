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
            completionHandler(result)
        }
    }
}
