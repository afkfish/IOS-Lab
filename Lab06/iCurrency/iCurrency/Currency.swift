//
//  Currency.swift
//  iCurrency
//
//  Created by Beni Kis on 18/10/2023.
//

import Foundation

struct Currency: Codable {
    let base: String
    let date: Date
    var rates: Rate
    
    struct Rate: Codable {
        let HUF: Double
    }
}


