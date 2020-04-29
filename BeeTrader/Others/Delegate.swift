import Foundation
import UIKit

protocol Delegate {
    func showHUD()
    func hideHUD()
    func presentFailure()
    func presentFailAlert(_ title: String)
    func changeAccessibility(to: Bool)
}

extension Delegate where Self: UIViewController {
    func presentFailure() {
        presentFailedRequestAlert()
    }

    func presentFailAlert(_ title: String) {
        presentFailAlert(title: title)
    }
    
    func changeAccessibility(to: Bool) {
           view.isUserInteractionEnabled = to
    }
}
