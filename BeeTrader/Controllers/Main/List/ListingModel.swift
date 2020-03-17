//
//  ListingModel.swift
//  BeeTrader
//
//  Created by hladek on 16/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//
import Foundation

public struct Listing: Codable {
    let title: String
    let price: Int
    let seen: Int
    let id: Int
    let distance: Double
}
