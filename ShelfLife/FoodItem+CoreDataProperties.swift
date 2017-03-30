//
//  FoodItem+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension FoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem");
    }

    @NSManaged public var barcode: Int16
    @NSManaged public var expBool: Bool
    @NSManaged public var expDate: NSDate?
    @NSManaged public var inFridge: Bool
    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var boughtDate: NSDate?
    @NSManaged public var toCategory: Category?
    @NSManaged public var toRecipe: Recipe?

}
