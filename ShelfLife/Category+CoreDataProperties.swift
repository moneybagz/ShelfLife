//
//  Category+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/31/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var toFoodItems: NSSet?

}

// MARK: Generated accessors for toFoodItems
extension Category {

    @objc(addToFoodItemsObject:)
    @NSManaged public func addToToFoodItems(_ value: FoodItem)

    @objc(removeToFoodItemsObject:)
    @NSManaged public func removeFromToFoodItems(_ value: FoodItem)

    @objc(addToFoodItems:)
    @NSManaged public func addToToFoodItems(_ values: NSSet)

    @objc(removeToFoodItems:)
    @NSManaged public func removeFromToFoodItems(_ values: NSSet)

}
