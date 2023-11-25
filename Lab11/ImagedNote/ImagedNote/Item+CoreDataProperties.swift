//
//  Item+CoreDataProperties.swift
//  ImagedNote
//
//  Created by Beni Kis on 25/11/2023.
//
//

import Foundation
import CoreData
import UIKit


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var imageName: String?
    
    public var image : UIImage? {
        get{
            if let imageName = imageName {
                if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName) {
                    do {
                        let imageData = try Data(contentsOf: fileURL)
                        return UIImage(data: imageData)
                    } catch {
                        print("Error loading image : \(error)")
                    }
                }
            }
            return nil
        }
        set{
            if let image = newValue {
                let newName = "\(UUID().uuidString).png"
                if let pngData = image.pngData(),
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(newName) {
                    try? pngData.write(to: path)
                    if self.imageName != nil {
                        deleteStoredImage()
                    }
                    self.imageName = newName
                }
            }
        }
    }
    
    
    public func deleteStoredImage()
    {
        if let imageName = imageName {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName){
                //hogy lássuk, mit törölünk ki (szimulátorhoz)
                print("deleting:\(path)")
                try? FileManager.default.removeItem(at: path)
            }
        }
    }
}

extension Item : Identifiable {

}
