//
//  UserDetailCoordinator.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class UserDetailCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()

        let storyboard = UIStoryboard(name: "UserDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.userDetail)
        navigationController.pushViewController(controller, animated: false)
    }
}
