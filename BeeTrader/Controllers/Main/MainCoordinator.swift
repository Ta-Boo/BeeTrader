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
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.mainTabBar) as! MainTabBarController
        controller.handleLogOut = { [weak self] in
            GlobalUser.dispose()
            self?.navigationController.setViewControllers([self!.registrationController], animated: true)
        }
        return controller
    }
    
    var registrationController: UIViewController {
        let storyboard = UIStoryboard(name: "Registration", bundle: nil)
        let controller: RegistrationViewController = storyboard.instantiateViewController(withIdentifier: ViewControllers.registration) as! RegistrationViewController
        controller.successfulLoginHandler = { [weak self] in
            self?.navigationController.setViewControllers([self!.mainTabBarController], animated: true)
        }
        return controller
    }


    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
//        navigationController.navigationBar.prefersLargeTitles = false
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        loadUser()
        
        if let _ = GlobalUser.shared {
            navigationController.pushViewController(mainTabBarController, animated: true)
        } else {
            navigationController.presentInFullScreen(registrationController, animated: false)
        }
    }

    private func loadUser() {
        if let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: user) {
                GlobalUser.shared = loadedUser
            }
        }
    }
}
