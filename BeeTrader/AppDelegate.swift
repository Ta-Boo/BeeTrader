import UIKit


var globalUser: User?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var applicationCoordinator: MainCoordinator?
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    let applicationCoordinator = MainCoordinator(window: window)
    
    self.window = window
    self.applicationCoordinator = applicationCoordinator
    
    applicationCoordinator.start()
    styleNavBar()
    loadUser()
    return true
  }
    
    func styleNavBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
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


