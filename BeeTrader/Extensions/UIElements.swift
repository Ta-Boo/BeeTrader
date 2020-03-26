//
//  UIElements.swift
//  BeeTrader
//
//  Created by hladek on 07/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

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

extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
}


extension UIView {
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIImageView {
    func loadImage(url imageUrl : String?,_ animated: Bool = false) {
        guard let urlString = imageUrl else {
            self.image = UIImage(named: "loading_placeholder")
            return
        }
        DispatchQueue.global().async { [weak self] in
            let url = URL(string: urlString)
            let data = try? Data(contentsOf: url!)

            if animated {
                DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.alpha = 0
                }, completion: nil)
                UIView.animate(withDuration: 0.3, animations: {
                    self?.alpha = 1
                }, completion: nil)
                    self?.image = UIImage(data: data!)
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data!)
                }
            }
        }
    }
}
