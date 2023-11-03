//
//  Message.swift
//  GeoMessenger
//
//  Created by Beni Kis on 02/11/2023.
//

import Foundation

struct Message : Identifiable, Codable {
    var id: String
    var sender: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case sender = "from_user"
        case content
    }
}

extension Message {
    static func getDummyData() -> [Message] {
        return [
            Message(id: "1", sender:"Joe", content: "First Message"),
            Message(id: "2", sender:"Joe", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
            Message(id: "3", sender:"Teo", content: "Third Message")
        ]
    }
}
