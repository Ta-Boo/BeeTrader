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
    func presentFailAlert(title: String = L10n.Alert.unknownFail , _ message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Common.ok, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    func presentFailedRequestAlert() {
        let alertController = UIAlertController(title: L10n.Alert.unknownFail, message: L10n.Alert.tryAgain, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Common.ok, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    func presentConfirmationAlert(title: String = L10n.Alert.futureEfect, handler : @escaping EmptyClosure) {
        let alertController = UIAlertController(title: title, message: L10n.Alert.confirm, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: L10n.Common.yes, style: .default) { _ in
            handler()
        })
        present(alertController, animated: true)
    }
    
    
}
