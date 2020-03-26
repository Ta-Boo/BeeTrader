//
//  ListingFilterViewController.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class ListingFilterViewController: ListingManager {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distance: UILabel!
    let viewModel = ListingFilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    func loadCategories() {
        showHUD()
        viewModel.loadCategories() { [weak self] response in
            switch response {
            case .success(let value) :
                self?.viewModel.filterTypes = value.data
                self?.tableView.reloadData()
            case .failure:
                self?.presentFailedRequestAlert()
            }
            self?.hideHUD()
        }
    }
    
    @IBAction func onDistanceChanged(_ sender: UISlider) {
        distance.text = "\(String(format: "%.2f", sender.value)) Km"
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        let categories = viewModel.filterTypes?.filter{ $0.isChoosen ?? false }.map{ $0.id }
        let filterData = ListingData(radius: Int(distanceSlider?.value ?? 500),
                                     categories: categories)
        viewModel.submitCompletion?(filterData)
        dismiss(animated: true)
    }
    
}

extension ListingFilterViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterTypes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterTypeCell
        cell.setData(data: viewModel.filterTypes![indexPath.row])
        cell.onSwitchTapped = { [weak self] isOn in
            self?.viewModel.filterTypes![indexPath.row].isChoosen = isOn
        }
        return cell
    }

}
