//
//  ListingDetailModel.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

struct ListingDetail: Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let image: String?
    let price: Int
    let views: Int
    let location: String?
    let userName: String?
    let email: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case id
        case userId = "user_id"
        case description
        case image
        case views = "seen"
        case location = "is_in"
        case userName = "first_nameee"
        case email
        case phone = "phone_number"
    }
}
