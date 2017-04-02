//
//  DAO.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.


import Foundation
import CoreData

class DAO {
    
    // FETCH FOOD ITEMS
    internal static func getFoodItems() -> NSFetchedResultsController<FoodItem> {
        
        let fetchResultsController: NSFetchedResultsController<FoodItem>
        
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        
        let inKitchenSort = NSSortDescriptor(key: "isInKitchen", ascending: false)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [inKitchenSort, nameSort]
        
        // create controller using ap delegate to retrieve context
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ad.persistentContainer.viewContext, sectionNameKeyPath: "isInKitchen", cacheName: nil)
        
        do{
            try fetchResultsController.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
        
        return fetchResultsController
    }
    
    // FETCH FOOD ITEMS FOR SPECIFIC CATEGORY
    internal static func getFoodItemsFor(category:Category) -> NSFetchedResultsController<FoodItem> {
        
        // declare fetch results controller
        let fetchResultsController: NSFetchedResultsController<FoodItem>
        
        // declare request for controller
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        
        // order for food items to be displayed
        let inKitchenSort = NSSortDescriptor(key: "isInKitchen", ascending: false)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [inKitchenSort, nameSort]
        
        // create predicate to filter by category
        let categoryPredicate = NSPredicate(format: "toCategory = %@", category)
        request.predicate = categoryPredicate
        
        // create controller using ap delegate to retrieve context
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ad.persistentContainer.viewContext, sectionNameKeyPath: "isInKitchen", cacheName: nil)
        
        do{
            try fetchResultsController.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
        
        return fetchResultsController
    }
    
    // FETCH CATEGORIES
    internal static func getCategories() -> NSFetchedResultsController<Category> {
        
        let fetchResultsController: NSFetchedResultsController<Category>
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [nameSort]
        
        // create controller using ap delegate to retrieve context
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ad.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try fetchResultsController.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
        
        return fetchResultsController
    }
}
