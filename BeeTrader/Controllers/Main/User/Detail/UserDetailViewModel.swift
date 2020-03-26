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
    var addressId: Int?
    var avatarChanged = false
    var userUpdateCompletion: StringClosure?
    var imagePicker: UIImagePickerController!


    func uploadData(image: UIImage?, parameters: Dictionary<String,String?>, successCompletionHandler: @escaping EmptyClosure, failureCompletionHandler: @escaping EmptyClosure) {
        let url = "\(ApiConstants.baseUrl)api/user"
        var images: [Image]
        if let img = image {
            images = [Image(name: "image", fileName: "image", data: img)]
        } else {
            images = []
        }
        
        
        UrlRequest<UploadResponse>().uploadImages(url: url, images: images, parameters: parameters, loadingProgressor: { progress in
            print(progress)
        }, successCompletion: {
            successCompletionHandler()
        },failureCompletion: {
            failureCompletionHandler()
        })
    }
    
    func avatarToUpload(_ imageView: UIImageView) -> UIImage? {
        if avatarChanged {
            return imageView.image
        } else {
            return nil
        }
    }
}
