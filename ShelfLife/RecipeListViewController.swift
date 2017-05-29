//
//  RecipeListViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 5/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var fetchResultsController: NSFetchedResultsController<RecipeFoodItem>!
    var fetchResultsController2: NSFetchedResultsController<FoodItem>!
    var recipe: Recipe!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchResultsController = DAO.getRecipeList(recipe: recipe)
        
        fetchResultsController.delegate = self
        
        if fetchResultsController.fetchedObjects != nil {
            fetchResultsController2 = DAO.getFoodItemsIn(recipeList: fetchResultsController.fetchedObjects!)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom methods
    
    func getFreshnessWith(foodItem: FoodItem) -> UIColor {
        
        // Get total time between bought date and expiration date
        let totalTime = foodItem.expDate?.timeIntervalSince(foodItem.boughtDate as! Date)
        
        print(foodItem.boughtDate)
        print(foodItem.expDate)
        print("TOTAL TIME \(totalTime) &&&&&&&&&&&&&&&")
        
        // Get elapsed time between now and bought date
        let now = Date()
        let elapsedTime = now.timeIntervalSince(foodItem.boughtDate as! Date)
        print("ELAPSED TIME \(elapsedTime) ********************")
        
        // Compute the increase percentage
        let percent:Int
        let percentage = (elapsedTime) / (totalTime)! * 100
        percent = Int(percentage)
        
        // Select color depending on increase percentage
        switch percent {
        case 0...50:
            return UIColor(red: 26.0/255, green: 189.0/255, blue: 22.0/255, alpha: 1.0)
        case 50...74:
            return UIColor(red: 237.0/255, green: 222.0/255, blue: 9.0/255, alpha: 1.0)
        case 75...87:
            return UIColor(red: 238.0/255, green: 150.0/255, blue: 10.0/255, alpha: 1.0)
        case 88...99:
            return UIColor(red: 236.0/255, green: 56.0/255, blue: 9.0/255, alpha: 1.0)
        default:
            return UIColor(red: 83.0/255, green: 44.0/255, blue: 5.0/255, alpha: 1.0)
        }
    }
    
    // MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let results = fetchResultsController.fetchedObjects
        if let results = results {
            return results.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeList", for: indexPath) as! RecipeListTableViewCell
        
        let recipeFoodItem = fetchResultsController.fetchedObjects?[indexPath.row]
        
        // Check if there is matching food item in kitchen and if there is get fresh color for text
        if let foodItemsArray = fetchResultsController2.fetchedObjects {
            for foodItem in foodItemsArray {
                print("\(foodItem.name)")
                if foodItem.name == recipeFoodItem?.name {
                    cell.foodLabel.textColor = getFreshnessWith(foodItem: foodItem)
                }
            }
        }
        
        cell.foodLabel.text = recipeFoodItem?.name
        cell.amountLabel.text = recipeFoodItem?.quantity
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
