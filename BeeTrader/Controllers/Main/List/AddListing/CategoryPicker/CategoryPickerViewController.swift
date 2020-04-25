//
//  CategoryPickerViewController.swift
//  BeeTrader
//
//  Created by hladek on 26/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit


protocol  CategoryPickerViewDelegate: Delegate{
    func reloadData()
}
extension CategoryPickerViewController: CategoryPickerViewDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

class CategoryPickerViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let viewModel = CategoryPickerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        localize()
    }
    
    func localize() {
        titleLabel.text = L10n.Listing.Add.Category.title
    }
}

extension CategoryPickerViewController: ListingManager {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPickerCell") as! CategoryPickerCell
        cell.setData(data: viewModel.categories[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categoryPickCompletion?(viewModel.categories[indexPath.row])
        dismiss(animated: true)
    }
}
