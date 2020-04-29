//
//  AddressPickerViewModel.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation

class AddressPickerViewModel: ViewModel {
    var delegate: AddressPickerViewDelegate?
    var addresses: [Address] = []
    var searchDebouncer: Debouncer?

    func viewModelDidLoad() {}

    func onFilterChangedHandler(search: String?) {
        guard let filter = search else { return }
        let debounceHandler: () -> Void = { [weak self] in
            if filter.isEmpty || filter.count < 3 { return }
            self?.loadAddresses(withParameters: RequestParameters.addresses(filter: filter))
        }
        guard let searchDebouncer = searchDebouncer else {
            let debouncer = Debouncer(handler: {})
            self.searchDebouncer = debouncer
            onFilterChangedHandler(search: search)
            return
        }

        searchDebouncer.invalidate()
        searchDebouncer.handler = debounceHandler
        searchDebouncer.call()
    }

    func loadAddresses(withParameters parameters: Parameters) {
        delegate?.showHUD()
        UrlRequest<[Address]>().handle(ApiConstants.addresses,
                                       methood: HTTPMethod.get,
                                       parameters: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                guard let addresses = response.data else {
                    self?.delegate?.presentFailure()
                    return
                }
                self?.addresses = addresses
                self?.delegate?.reloadTableView()
            case .failure:
                self?.delegate?.presentFailure()
            }
            self?.delegate?.hideHUD()
        }
    }
}
