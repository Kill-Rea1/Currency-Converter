//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

class Currency: Codable, Equatable {
    
    let shortName: String
    let fullName: String
    var ratio: Double
    var index: Int
    
    required init(fullName: String, shortName: String, ratio: Double, index: Int) {
        self.fullName = fullName
        self.shortName = shortName
        self.ratio = ratio
        self.index = index
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.fullName == rhs.fullName && lhs.shortName == rhs.shortName && lhs.ratio == rhs.ratio && lhs.index == rhs.index {
            return true
        }
        return false
    }
    
    static func defaultCurrency1() -> Currency {
        let currency = self.init(fullName: "United States Dollar", shortName: "USD", ratio: 1, index: 0)
        return currency
    }
    
    static func defaultCurrency2() -> Currency {
        let currency = self.init(fullName: "Euro", shortName: "EUR", ratio: 0.8, index: 1)
        return currency
    }
}
