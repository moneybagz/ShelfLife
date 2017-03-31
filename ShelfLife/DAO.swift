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
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        let inKitchenSort = NSSortDescriptor(key: "isInKitchen", ascending: true)
        request.sortDescriptors = [nameSort, inKitchenSort]
        
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
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
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
