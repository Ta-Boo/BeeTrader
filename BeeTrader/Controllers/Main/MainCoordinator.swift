import UIKit

// var globalUser: User?

protocol MainCoordinatorType {
    var mainTabBarController: UIViewController { get }
    var registrationController: UIViewController { get }
}

class MainCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    
    var mainTabBarController: UIViewController {
        let controller = StoryboardScene.MainTabBar.mainTabBarController.instantiate()
        controller.handleLogOut = { [weak self] in
            GlobalUser.shared.dispose()
            self?.navigationController.setViewControllers([self!.registrationController], animated: true)
        }
        return controller
    }
    
    var registrationController: UIViewController {
        let controller = StoryboardScene.Registration.initialScene.instantiate()
        controller.viewModel.okLoginHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController.setViewControllers([self.mainTabBarController], animated: true)
        }
        return controller
    }


    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        loadUser()
        
        if let _ = GlobalUser.shared.user {
            navigationController.pushViewController(mainTabBarController, animated: true)
        } else {
            navigationController.pushViewController(registrationController, animated: false)
        }
    }

    private func loadUser() {
        if let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: user) {
                GlobalUser.shared.update(loadedUser)
                
            }
        }
    }
}
