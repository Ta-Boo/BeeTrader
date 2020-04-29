//
//  ListingCell.swift
//  BeeTrader
//
//  Created by hladek on 14/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import UIKit

class ListingCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var views: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet weak var ownerMark: UIImageView!
    
    func setData(data: Listing) {
        image.image = Asset.loadingPlaceholder.image
        if let listingImage = data.image {
            image.imageFromUrl(ApiConstants.getImage(postFix: listingImage), useCached: true, true)
        }
        
        if data.email == GlobalUser.shared.user?.email {
            ownerMark.isHidden = false
        }  else {
            ownerMark.isHidden = true
        }
        title.text = data.title
        distance.text = "\(data.distance)Km"
        views.text = String(data.seen)
        price.text = data.price.toPrice()
    }
}
