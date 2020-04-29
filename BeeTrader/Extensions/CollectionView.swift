import Foundation
import UIKit

extension UICollectionView {
    public func dequeueReusableCell<T:UICollectionViewCell>(type: T.Type , indexPath: IndexPath) -> T {
        let cellIdentifier  = String(describing: T.self)
        
        if let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? T {
            return cell
        }
        fatalError()
    }
    
}
