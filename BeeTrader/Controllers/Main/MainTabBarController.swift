//
//  MainTabBarController.swift
//  BeeTrader
//
//  Created by hladek on 13/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var handleLogOut: EmptyClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        notifyInit()
        }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
        switch tabBarIndex {
        case 0:
            tabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logOutTapped))
        default:
            clearNavBarItems()
        }
    }
    
    @objc func logOutTapped(_ sender: UIBarButtonItem) {
        handleLogOut?()
    }
    
    func notifyInit() {
        self.selectedIndex = 0
        self.tabBarController(self, didSelect: self.viewControllers![0])
    }
    
    func clearNavBarItems() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
    
}
