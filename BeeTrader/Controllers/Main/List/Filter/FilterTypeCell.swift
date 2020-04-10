//
//  FilterTypeCell.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class FilterTypeCell: UITableViewCell {
    @IBOutlet var type: UILabel!
    @IBOutlet var choosenSwitch: UISwitch!
    var onSwitchTapped: BoolClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        choosenSwitch.onTintColor = UIColor(named: "PrimaryColor")
    }

    func setData(data: Category) {
        choosenSwitch.isOn = data.isChoosen ?? false
        type.text = data.type
    }

    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        onSwitchTapped?(sender.isOn)
    }
}
