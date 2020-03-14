import UIKit

class MainCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = false
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if let _ = UserDefaults.standard.string(forKey: StorageKeys.apiToken) {
            let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.mainTabBar)
            navigationController.pushViewController(controller, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Registration", bundle: nil)
            let controller: RegistrationViewController = storyboard.instantiateViewController(withIdentifier: ViewControllers.registration) as! RegistrationViewController
            controller.successfulLoginHandler = {
                let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.mainTabBar)
                self.navigationController.pushViewController(controller, animated: true)
            }
            navigationController.presentInFullScreen(controller, animated: true)
        }
    }
}
