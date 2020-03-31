//
//  AddressPickerViewController.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

typealias ListingManager = UIViewController & UITableViewDataSource & UITableViewDelegate

class AddressPickerViewController: UIViewController, UITableViewDataSource {
    let viewModel = AddressPickerViewModel()
    var addressPickCompletion: ((Address) -> Void)?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    @IBAction func onFilterChanged(_ sender: UITextField) {
        onFilterChangedHandler(sender)
    }
}

extension AddressPickerViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
        cell.setData(data: viewModel.addresses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressPickCompletion?(viewModel.addresses[indexPath.row])
        dismiss(animated: true)
    }
}

extension AddressPickerViewController: AddressPickerViewDelegate {
    
    func loadAddressesWithFilter(_ filter: String) {
        let parameters = RequestParameters.addresses(filter: filter)
        showHUD()
        viewModel.loadAddresses(parameters: parameters)
    }
    
    func addressesLoadedFailure() {
        hideHUD()
        presentFailedRequestAlert()
    }
    
    func addressesLoadedSuccess(addresses: [Address]) {
        viewModel.addresses = addresses
        tableView.reloadData()
        hideHUD()
    }
    
    func onFilterChangedHandler(_ sender: UITextField) {
        guard let filter = sender.text else { return }
        let debounceHandler: () -> Void = { [weak self] in
            if filter.isEmpty || filter.count < 3 { return }
            self?.loadAddressesWithFilter(filter)
        }
        
        guard let searchDebouncer = self.viewModel.searchDebouncer else {
            let debouncer = Debouncer(handler: {})
            self.viewModel.searchDebouncer = debouncer
            onFilterChangedHandler(sender)
            return
        }
        
        searchDebouncer.invalidate()
        searchDebouncer.handler = debounceHandler
        searchDebouncer.call()
    }

}
