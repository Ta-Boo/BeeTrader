//
//  AddressPickerViewModel.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

protocol AddressPickerViewDelegate {
    func loadAddressesWithFilter(_ filter: String)
    func addressesLoadedFailure()
    func addressesLoadedSuccess(addresses: [Address])
    func onFilterChangedHandler(_ sender: UITextField)
}

class AddressPickerViewModel {
    var delegate: AddressPickerViewDelegate?
    var addresses: [Address] = []
    var searchDebouncer: Debouncer?

    func loadAddresses(parameters: Parameters) {
        UrlRequest<[Address]>().handle(ApiConstants.baseUrl + "api/addresses",
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                guard let addresses = response.data else {
                    self?.delegate?.addressesLoadedFailure()
                    return
                }
                self?.delegate?.addressesLoadedSuccess(addresses: addresses)
            case .failure:
                self?.delegate?.addressesLoadedFailure()
            }
        }
    }
}
