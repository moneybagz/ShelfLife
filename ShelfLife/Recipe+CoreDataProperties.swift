//
//  Recipe+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 5/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var toRecipeFoodItem: NSSet?

}

// MARK: Generated accessors for toRecipeFoodItem
extension Recipe {

    @objc(addToRecipeFoodItemObject:)
    @NSManaged public func addToToRecipeFoodItem(_ value: RecipeFoodItem)

    @objc(removeToRecipeFoodItemObject:)
    @NSManaged public func removeFromToRecipeFoodItem(_ value: RecipeFoodItem)

    @objc(addToRecipeFoodItem:)
    @NSManaged public func addToToRecipeFoodItem(_ values: NSSet)

    @objc(removeToRecipeFoodItem:)
    @NSManaged public func removeFromToRecipeFoodItem(_ values: NSSet)

}
