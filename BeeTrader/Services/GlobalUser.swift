import Foundation
import KeychainSwift


class GlobalUser {
    private init() {}

    private static var _shared: User?
    static var shared: User? {
        get {
            guard let user = UserDefaults.standard.object(forKey: StorageKeys.user) as? Data else {
                return nil
            }
            if let loadedUser = try? JSONDecoder().decode(User.self, from: user) {
                _shared = loadedUser
                return _shared
            } else { return nil }
        }
        set { _shared = newValue }
    }

    
    static func update(_ user: User?) {
//        if user?.token == nil {
//            user?.token = shared?.token
//        }
        
        if let token = user?.token {
            KeychainSwift().set(token, forKey: "bearer_token")
        }
        if let encoded = try? JSONEncoder().encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: StorageKeys.user)
        }
    }
    static func dispose() {
        UserDefaults.standard.set(nil, forKey: StorageKeys.user)
    }
}
