//
//  AddressMoodel.swift
//  BeeTrader
//
//  Created by hladek on 20/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation

class Address: Codable {
    let id: Int
    let name: String
    let postalCode: String
   
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case postalCode = "postal_code"
    }
}
