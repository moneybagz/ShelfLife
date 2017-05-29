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
    
    // FETCH RECIPES
    internal static func getRecipes() -> NSFetchedResultsController<Recipe> {
        
        let fetchResultsController: NSFetchedResultsController<Recipe>
        
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    
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
    
    // FETCH RECIPE FOOD ITEMS
    internal static func getRecipeList(recipe: Recipe) -> NSFetchedResultsController<RecipeFoodItem> {
        
        let fetchResultsController: NSFetchedResultsController<RecipeFoodItem>
        
        let request: NSFetchRequest<RecipeFoodItem> = RecipeFoodItem.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [nameSort]
        
        // create predicate to filter by recipe
        let recipePredicate = NSPredicate(format: "toRecipe = %@", recipe)
        request.predicate = recipePredicate
        
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
    
    // FETCH FOOD ITEMS IN RECIPE LIST
    internal static func getFoodItemsIn(recipeList: [RecipeFoodItem]) -> NSFetchedResultsController<FoodItem> {
        
        let fetchResultsController: NSFetchedResultsController<FoodItem>
        
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [nameSort]
        
//        // Predicate to only find food items that is also in your recipe list
//        let predicate1 = NSPredicate(format:"name IN %@", recipeList)
        
        // Predicate to only take food items that are in fridge
        let predicate2 = NSPredicate(format: "isInKitchen == %@", NSNumber(booleanLiteral: true))
        
//        // combining predicates into compound predicate
//        let compound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        request.predicate = predicate2

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
