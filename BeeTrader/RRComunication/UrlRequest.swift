//
//  Request.swift
//  BeeTrader
//
//  Created by hladek on 05/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation
import KeychainSwift



struct ApiConstants {
//    private static let baseUrl = "http://localhost:8000/api"
    private static let baseUrl = "http://192.168.0.110:8000/api"
    static let login = "\(baseUrl)/login"
    static let register = "\(baseUrl)/register"
    static let updateUser = "\(baseUrl)/user"
    static let getUser = "\(baseUrl)/userByEmail"
    
    static let listing = "\(baseUrl)/listing"
    static let listings = "\(baseUrl)/listings/inRadius"
    static let updateListing = "\(baseUrl)/listingUpdate"
    
    
    static let categories = "\(baseUrl)/categories"
    static let addresses = "\(baseUrl)/addresses"
    
    static func getImage(postFix: String) -> String {
        return "\(baseUrl)/\(postFix)"
    }
}

struct Image {
    var name: String
    var fileName: String
    var data: UIImage
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
            encoding: encoding,
            headers: RequestHeaders.authorization
        ).validate().responseJSON { response in
            let result = Result<DataWrapper<WrappedData>>(value: {
                try JSONDecoder().decode(DataWrapper<WrappedData>.self, from: response.data!)
            })
            completionHandler(result)
        }
    }

    func uploadImages(url: String,
                        images: [Image],
                      parameters: Dictionary<String,String?>? = nil,
                      headers: HTTPHeaders? = nil,
                      loadingProgressor: @escaping DoubleClosure,
                      successCompletion: @escaping EmptyClosure,
                      failureCompletion: @escaping EmptyClosure
                      ) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for image in images {
                if let imageData = image.data.jpegData(compressionQuality: 0.02) {
                    multipartFormData.append(imageData, withName: image.name, fileName: image.fileName, mimeType: "image/jpg")
                }
            }
            if let params = parameters {
                for (key, value) in params {
                    if let data = value  {
                        multipartFormData.append(data.data(using: .utf8) ?? "".data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, to: url,
           method: .post,
           headers: RequestHeaders.authorization) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        loadingProgressor(progress.fractionCompleted)
                    })
                    upload.validate().responseJSON { result in
                        if result.data != nil {
                            successCompletion()
                        }
                    }
                case .failure:
                    failureCompletion()
                }
            }
        }
}
