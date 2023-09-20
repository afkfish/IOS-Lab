//
//  PictureManager.swift
//  PictureGuess
//
//  Created by Beni Kis on 17/09/2023.
//

import Foundation
import UIKit

class PictureManager: NSObject {
    private let pictures: [AnyObject]?
    private let choices = 3
    
    public static var requestedPictureCount = 0
    public static var correctGuessCount = 0
    public static var wrongGuessCount = 0
    
    override init() {
        let picturesAsset = NSDataAsset(name: "Pictures")
        
        do {
            var format = PropertyListSerialization.PropertyListFormat.xml
            pictures = try PropertyListSerialization.propertyList(from: picturesAsset!.data, options: .mutableContainersAndLeaves, format: &format) as? [AnyObject]
        } catch {
            pictures = nil
        }
        super.init()
    }
    
    func getRandomPicture(_ picture: inout UIImage?, titles: inout [String], pictureTitleIndex: inout Int) {
        guard let pictures = pictures else {
            return
        }

        // kiválasztott kép indexe a `pictures` tömbben
        let selectedPictureIndex = Int(arc4random_uniform(UInt32(pictures.count - 1)))

        // tömb a még ki nem választott képcímek indexével
        var rangeArray = [Int]()
        for index in 0..<pictures.count {
            rangeArray.append(index)
        }
        rangeArray.remove(at: selectedPictureIndex)
        print("range array: \(rangeArray)")

        // egyedi véletlen képcímek kiválasztása
        var titlesToReturn = [String]()
        for _ in 0..<choices - 1 {
            let randomIndex = Int(arc4random_uniform(UInt32(rangeArray.count - 1)))
            if let randomPicture = pictures[rangeArray[randomIndex]] as? [String : String] {
                titlesToReturn.append(randomPicture["title"]!)
            }
            rangeArray.remove(at: randomIndex)
        }
        print("titles: \(titlesToReturn)")

        // választott képcím beszúrása a véletlen képcímek közé, véletlen helyre :)
        pictureTitleIndex = Int(arc4random_uniform(UInt32(choices)))
        if let chosenPicture = pictures[selectedPictureIndex] as? [String: String] {
            titlesToReturn.insert(chosenPicture["title"]!, at: pictureTitleIndex)
            picture = UIImage(named: chosenPicture["image"]!)!
        }

        titles = titlesToReturn
        PictureManager.requestedPictureCount += 1
    }
}
