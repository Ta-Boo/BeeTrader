import Foundation
import KeychainSwift


class GlobalUser {
    private init() {}
    static var shared = GlobalUser()
    var user: User? {
        get {
            guard let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data else {
                return nil
            }
            if let loadedUser = try? JSONDecoder().decode(User.self, from: user) {
                return loadedUser
            } else { return nil }
        }
    }

     func update(_ user: User?) {
        if let token = user?.token {
            KeychainSwift().set(token, forKey: KeychainKeys.token)
        }
        if let encoded = try? JSONEncoder().encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: StorageKeys.user)
        }
    }
     func dispose() {
        UserDefaults.standard.set(nil, forKey: StorageKeys.user)
    }
}
