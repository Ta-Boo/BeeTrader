//
//  ListingFilterViewController.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

protocol ListingFilterViewDelegate: Delegate {
    func showCategories()
}

class ListingFilterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var distance: UILabel!
    let viewModel = ListingFilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
    }

    @IBAction func onDistanceChanged(_ sender: UISlider) {
        distance.text = "\(String(format: "%.2f", sender.value)) Km"
    }

    @IBAction func onSubmitClicked(_: Any) {
        viewModel.handleSubmit(distance: Int(distanceSlider.value))
        dismiss(animated: true)
    }
}
// MARK: Delegate
extension ListingFilterViewController: ListingFilterViewDelegate {
    func showCategories() {
        tableView.reloadData()
    }
}

// MARK: TableView

extension ListingFilterViewController: ListingManager {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.filterTypes?.count ?? 0
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterTypeCell
        cell.setData(data: viewModel.filterTypes![indexPath.row])
        cell.onSwitchTapped = { [weak self] isOn in
            self?.viewModel.filterTypes![indexPath.row].isChoosen = isOn
        }
        return cell
    }
}
