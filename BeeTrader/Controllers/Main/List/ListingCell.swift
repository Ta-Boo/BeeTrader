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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: Listing) {
        if let listingImage = data.image {
            image.loadImage(url: "\(ApiConstants.baseUrl)\(listingImage)", true)
        } else {
            image.loadImage(url: nil)
        }
        title.text = data.title
        distance.text = String(data.distance)
        views.text = String(data.seen)
        price.text = data.price.toPrice()
    }
}
