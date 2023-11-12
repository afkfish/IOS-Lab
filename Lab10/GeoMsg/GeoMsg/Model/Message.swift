//
//  Message.swift
//  GeoMsg
//
//  Created by László Blázovics on 2021. 11. 10..
//

import Foundation
import CoreLocation

struct Message : Identifiable, Codable{
    var id: Int
    var sender: String
    var content: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var threadId : Int = 1
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case sender = "from_user"
        case content
        case longitude
        case latitude
        case threadId = "thread_id"
    }
}
