//
//  CategoryPickerViewModel.swift
//  BeeTrader
//
//  Created by hladek on 26/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import Alamofire

class CategoryPickerViewModel: ViewModel {
    var categories: [Category] = []
    var delegate: CategoryPickerViewDelegate?
    var categoryPickCompletion: ((Category) -> Void)?


    func viewModelDidLoad() {
        loadCategories()
    }
    
    func loadCategories() {
        delegate?.showHUD()
        UrlRequest<[Category]>().handle(ApiConstants.baseUrl + "categories",
                                        methood: HTTPMethod.get) { [weak self] result in
                                            self?.delegate?.hideHUD()
                                            switch result {
                                            case .failure:
                                                self?.delegate?.presentFailure()
                                            case .success(let response):
                                                guard let categories = response.data else {
                                                    self?.delegate?.presentFailure()
                                                    return
                                                }
                                                self?.categories = categories
                                                self?.delegate?.reloadData()
                                            }
        }
    }
    
}
