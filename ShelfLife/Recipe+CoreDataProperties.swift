//
//  Recipe+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/21/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var toRecipeFoodItems: NSSet?

}

// MARK: Generated accessors for toRecipeFoodItems
extension Recipe {

    @objc(addToRecipeFoodItemsObject:)
    @NSManaged public func addToToRecipeFoodItems(_ value: RecipeFoodItem)

    @objc(removeToRecipeFoodItemsObject:)
    @NSManaged public func removeFromToRecipeFoodItems(_ value: RecipeFoodItem)

    @objc(addToRecipeFoodItems:)
    @NSManaged public func addToToRecipeFoodItems(_ values: NSSet)

    @objc(removeToRecipeFoodItems:)
    @NSManaged public func removeFromToRecipeFoodItems(_ values: NSSet)

}
