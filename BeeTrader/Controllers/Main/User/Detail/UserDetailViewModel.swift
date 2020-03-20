//
//  UserDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//
import Alamofire
import Foundation

class UserDetailViewModel {
    func uploadData(image: UIImage, parameters: Parameters) {
        let url = "\(ApiConstants.baseUrl)api/user"
        let images = [Image(name: "image", fileName: "image", data: image)]
        
        
        UrlRequest<UploadResponse>().uploadImages(url: url, images: images, parameters: parameters, loadingProgressor: { progress in
            print(progress)
        }, successCompletion: {
            print("success")
        }) {
            print("failure")
        }
    }
}
