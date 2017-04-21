//
//  RecipeFoodItem+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/21/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension RecipeFoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeFoodItem> {
        return NSFetchRequest<RecipeFoodItem>(entityName: "RecipeFoodItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var toRecipe: Recipe?

}
