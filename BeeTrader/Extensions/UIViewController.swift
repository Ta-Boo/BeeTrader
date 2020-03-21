//
//  UIViewController.swift
//  BeeTrader
//
//  Created by hladek on 17/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentFailAlert(title: String, _ message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true)
    }
    func presentFailedRequestAlert(){
        let alertController = UIAlertController(title: "Something went wrong", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true)
    }
}
