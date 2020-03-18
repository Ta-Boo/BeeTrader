//
//  UserDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 18/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class UserDetailViewController: UITableViewController, UITextFieldDelegate {
    
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
