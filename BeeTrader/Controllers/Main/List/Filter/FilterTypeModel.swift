//
//  FilterTypeModel.swift
//  BeeTrader
//
//  Created by hladek on 24/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation


struct Category: Codable {
    let id: Int
    let type: String
    var isChoosen: Bool? = false
    
}

