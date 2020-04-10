//
//  MainTabBarController.swift
//  BeeTrader
//
//  Created by hladek on 13/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    var handleLogOut: EmptyClosure?
    var userController: UserViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        userController = viewControllers?[0] as? UserViewController
    }
    
}
