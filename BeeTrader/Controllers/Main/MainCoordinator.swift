import UIKit

//var globalUser: User?
class GlobalUser {
    static var shared: () -> User? =  {
        if let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: user) {
                return loadedUser
            }
        }
        return nil
    }
    private init() {}
}

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
        
        loadUser()
        if let _ = globalUser {
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
            navigationController.presentInFullScreen(controller, animated: false)
        }
    }
    
    private func loadUser() {
        if let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: user) {
                globalUser = loadedUser
            }
        }
    }
}
