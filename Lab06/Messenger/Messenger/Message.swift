//
//  Message.swift
//  Messenger
//
//  Created by Beni Kis on 18/10/2023.
//  Copyright © 2023 BME AUT. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    let sender: String
    let recipient: String
    let topic: String
    let content: String = ""
    var image: String?
    let imageUrl: String?
    
    init(sender: String, recipient: String, topic: String) {
        self.sender = sender
        self.recipient = recipient
        self.topic = topic
        self.imageUrl = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case sender = "from_user"
        case recipient = "to_user"
        case topic
        case content
        case image
        case imageUrl = "imageurl"
    }
}
