//
//  FoodItem+CoreDataProperties.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 5/17/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import CoreData


extension FoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }

    @NSManaged public var barcode: Int64
    @NSManaged public var boughtDate: NSDate?
    @NSManaged public var expDate: NSDate?
    @NSManaged public var isInKitchen: Bool
    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var quantity: Int16
    @NSManaged public var uuid: String?
    @NSManaged public var toCategory: Category?

}
