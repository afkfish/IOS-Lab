//
//  NameHandler.swift
//  iNames
//
//  Created by Beni Kis on 05/10/2023.
//

import Foundation

class NameHandler {
    let names: [AnyObject]?

    static let shared = NameHandler()

    private init() {
        let path = Bundle.main.path(forResource: "Names", ofType: "plist")
        names = NSArray(contentsOfFile: path!)! as [AnyObject]
    }
}
