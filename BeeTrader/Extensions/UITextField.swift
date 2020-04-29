import Foundation
import UIKit

extension UITextField {
    func isEmpty() -> Bool {
        return text?.isEmpty ?? true
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
    
    func enableEditing() {
        isEnabled = true
        underline()
    }
    
    func underline(_ color: UIColor = UIColor.white) {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
