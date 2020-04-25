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
//    static let baseUrl = "http://localhost:8000/api/"
    static let baseUrl = "http://192.168.0.110:8000/api/"
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
            headers: ["Authorization": KeychainSwift().get("bearer_token") ?? ""]
        ).validate().responseJSON { response in
            print(response)
            let result = Result<DataWrapper<WrappedData>>(value: {
                try JSONDecoder().decode(DataWrapper<WrappedData>.self, from: response.data!)
            })
            switch result {
            case .failure(let error):
                print("error reason : ", error)
            case .success(let data):
                print("RESPONSE: ",data.data ?? "no data")
            }
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
           headers: ["Authorization": KeychainSwift().get("bearer_token") ?? ""]) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        loadingProgressor(progress.fractionCompleted)
                    })
                    upload.validate().responseJSON { result in
                        if let data = result.data {
                            print("RESPONSE: ",String(data: data, encoding: String.Encoding.utf8) ?? "cannot decode response")
                            successCompletion()
                        }
                    }
                case .failure:
                    failureCompletion()
                }
            }
        }
}
