
import Foundation
import Lottie
import UIKit

class SingleAnimationView {
    static var shared = SingleAnimationView()
    lazy var view = AnimationView(name: "loading")
    private init() {}
}

extension UIViewController {
    func showHUD() {
        DispatchQueue.main.async { [weak self] in
            let hud = SingleAnimationView.shared.view
            hud.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            hud.center = self?.view.center ?? CGPoint(x: 0, y: 0)
            hud.contentMode = .scaleAspectFill
            self?.view.addSubview(hud)
            hud.loopMode = .loop
            hud.play()
        }
    }

    func hideHUD() {
        DispatchQueue.main.async {
            SingleAnimationView.shared.view.removeFromSuperview()
        }
    }
}
