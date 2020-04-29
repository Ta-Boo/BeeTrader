import Foundation
import UIKit

extension UITableView {
    
    public func dequeueReusableCell<T:UITableViewCell>(type: T.Type) -> T {
        let cellIdentifier  = String(describing: T.self)

        if let cell = self.dequeueReusableCell(withIdentifier: cellIdentifier) as? T {
            return cell
        }
        fatalError()
    }
}
