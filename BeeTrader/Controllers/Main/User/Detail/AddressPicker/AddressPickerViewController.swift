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

class AddressPickerViewController: ListingManager {
    let viewModel = AddressPickerViewModel()
    var addressPickCompletion: ((Address) -> Void)?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadAddresses(filter: String) {
        let parameters = RequestParameters.addresses(filter: filter)
        showHUD()
        viewModel.loadAddresses(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let data):
                self?.viewModel.addresses = data.data ?? []
                self?.tableView.reloadData()
                self?.hideHUD()
            case.failure:
                self?.hideHUD()
                self?.presentFailedRequestAlert()
            }
        }
    }
    
    @IBAction func onFilterChanged(_ sender: UITextField) {
        guard let filter = sender.text else { return }
        let debounceHandler: () -> Void = { [weak self] in
            if filter.isEmpty || filter.count < 3 { return }
            self?.loadAddresses(filter: filter)
        }
        
        guard let searchDebouncer = self.viewModel.searchDebouncer else {
            let debouncer = Debouncer(handler: {})
            self.viewModel.searchDebouncer = debouncer
            onFilterChanged(sender)
            return
        }
        
        searchDebouncer.invalidate()
        searchDebouncer.handler = debounceHandler
        searchDebouncer.call()
    }
}

extension AddressPickerViewController {
    
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
