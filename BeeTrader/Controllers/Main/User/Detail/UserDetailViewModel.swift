//
//  UserDetailViewModel.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//
import Alamofire
import Foundation

class UserDetailViewModel: ViewModel {
    var addressId: Int?
    var avatarChanged = false
    var userUpdateCompletion: StringClosure?
    var delegate: UserDetailViewDelegate!

    func viewModelDidLoad() {
        setupViews()
    }

    func setupViews() {
        guard let globalUser = GlobalUser.shared.user else {
            delegate?.presentFailure()
            return
        }
        delegate?.updateViews(user: globalUser)
    }

    func uploadData(withParameters parameters: WeakParameters, image: UIImage?) {
        let url = ApiConstants.updateUser
        UrlRequest<Dump>().uploadImages(url: url, images: image.toImageArray(),
                                        parameters: parameters, loadingProgressor: { _ in
        }, successCompletion: { [weak self] in
            self?.delegate.completionHandler()
        }, failureCompletion: { [weak self] in
            self?.delegate.presentFailure()
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
