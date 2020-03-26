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
    func presentFailAlert(title: String = "Something went wrong.", _ message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    func presentFailedRequestAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    func presentConfirmationAlert(handler : @escaping EmptyClosure) {
        let alertController = UIAlertController(title: "Are you sure? ", message: "This action will affext usage of this app in future.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "I am", style: .default) { _ in
            handler()
        })
        present(alertController, animated: true)
    }
}
