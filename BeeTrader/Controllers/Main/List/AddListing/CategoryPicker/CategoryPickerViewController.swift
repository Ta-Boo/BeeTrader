//
//  CategoryPickerViewController.swift
//  BeeTrader
//
//  Created by hladek on 26/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class CategoryPickerViewController: ListingManager {
    @IBOutlet var tableView: UITableView!
    var categoryPickCompletion: ((Category) -> Void)?

    let viewModel = CategoryPickerViewModel()
}

extension CategoryPickerViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.setupData(category: viewModel.categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        categoryPickCompletion?(viewModel.categories[indexPath.row])
    }
}




