//
//  Thread.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import Foundation

struct Thread : Identifiable, Codable{
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "thread_id"
        case name
    }
}
