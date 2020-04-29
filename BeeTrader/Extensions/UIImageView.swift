import Foundation
import UIKit
import Alamofire

extension UIImageView {
    
    func imageFromUrl(_ url : String?, useCached: Bool, _ animated: Bool = false) {
        guard let url = url ,
            var request = try? URLRequest(url: url,
                                          method: .get,
                                          headers: RequestHeaders.authorization)
            else { return }
        request.cachePolicy = useCached ?
            URLRequest.CachePolicy.returnCacheDataElseLoad : URLRequest.CachePolicy.reloadIgnoringCacheData
        
        Alamofire.request(request)
            .responseData { [weak self] response in
                switch response.value {
                case .none:
                    return
                case .some(let data):
                    self?.image = UIImage(data: data)
                }
        }
    }
}

extension Optional where Wrapped == UIImage {
    
    func toImageArray() -> [Image] {
        var images: [Image]
        if let img = self {
            images = [Image(name: "image", fileName: "image", data: img)]
        } else {
            images = []
        }
        return images
    }
}
