//
//  AddressPickerViewController.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

protocol AddressPickerViewDelegate: Delegate {
    func reloadTableView()
}

class AddressPickerViewController: UIViewController {
    let viewModel = AddressPickerViewModel()
    var addressPickCompletion: ((Address) -> Void)?

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        localize()
    }

    func localize() {
        searchBar.placeholder = L10n.User.addressHint
    }
    @IBAction func onFilterChanged(_ sender: UITextField) {
        viewModel.onFilterChangedHandler(search: sender.text)
    }
}

extension AddressPickerViewController: ListingManager {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.addresses.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: AddressCell.self)
        cell.setData(data: viewModel.addresses[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressPickCompletion?(viewModel.addresses[indexPath.row])
        dismiss(animated: true)
    }
}

extension AddressPickerViewController: AddressPickerViewDelegate {
    func reloadTableView() {
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.tableView.reloadData() })
    }
}
