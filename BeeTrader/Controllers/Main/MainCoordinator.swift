import UIKit

//var globalUser: User?
class GlobalUser {
    private init() {}

    private static var _shared: User? = nil
    static var shared : User?  {
        get {
            guard let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data else {
                return nil
            }
            if let loadedUser = try? JSONDecoder().decode(User.self, from: user) {
                _shared = loadedUser
                return _shared
            } else { return nil }
        }
        set { self._shared = newValue }
    }
    static func update(_ user: User?) {
        if let encoded = try? JSONEncoder().encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: StorageKeys.user)
        }
    }
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
        if let _ = GlobalUser.shared {
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
                GlobalUser.shared = loadedUser
            }
        }
    }
}
