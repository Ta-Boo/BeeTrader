//
//  Primitives.swift
//  BeeTrader
//
//  Created by hladek on 22/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation


extension Int {
    func toPrice() -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.locale = Locale(identifier: "sk_SK")
        return "\(numFormatter.string(from: NSNumber(value: self/100)) ?? "0")€"
    }
}
