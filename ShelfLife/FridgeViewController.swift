//
//  FridgeViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class FridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    
    var foodItems = [FoodItem]()
    var foodItemsInFridge = [FoodItem]()
    var foodItemsNotInFridge = [FoodItem]()
    let headerTitles = ["In my fridge", "No longer in fridge"]
    var fetchResultsController: NSFetchedResultsController<FoodItem>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //testData()

        
        // WHY DOES THIS METHOD HAVE TO BE STATIC?
        fetchResultsController = DAO.getFoodItems()
        fetchResultsController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
        
//        var count = 0
//        //NOT YET
////        foodItemsInFridge.removeAll()
////        foodItemsNotInFridge.removeAll()
//
//        // Get number of items in each section using food's expiration bool
//        if section == 0 {
//            for foodItem in foodItems {
//                if foodItem.expBool == true {
//                    count += 1
//                    foodItemsInFridge.append(foodItem)
//                }
//            }
//        } else {
//            for foodItem in foodItems {
//                if foodItem.expBool == false {
//                    count += 1
//                    foodItemsNotInFridge.append(foodItem)
//                }
//            }
//        }
//        
//        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as! FridgeTableViewCell
        
        let foodItem = fetchResultsController.object(at: indexPath)
        
        // Configure the cell...
//        if indexPath.section == 0 {
//            cell.foodItemLabel.text = foodItemsInFridge[indexPath.row].name
//        }
//        else {
//            cell.foodItemLabel.text = foodItemsNotInFridge[indexPath.row].name
//        }
        
        cell.foodItemLabel.text = foodItem.name
        
        return cell
    }
    
    
    func testData(){
        let foodItem1 = FoodItem(context: context)
        foodItem1.name = "cheese"
        foodItem1.expBool = true
        
        let foodItem2 = FoodItem(context: context)
        foodItem2.name = "Pear"
        foodItem2.expBool = false
        
        let foodItem3 = FoodItem(context: context)
        foodItem3.name = "Filet Mignon"
        foodItem3.expBool = false
        
        foodItems.append(foodItem1)
        foodItems.append(foodItem2)
        foodItems.append(foodItem3)
        
        let category1 = Category(context: context)
        category1.name = "Meats"
        if let image = UIImage(named: "meats") {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category1.picture = data as NSData?
        }
        
        let category2 = Category(context: context)
        category2.name = "Dairy"
        if let image = UIImage(named: "dairy") {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category2.picture = data as NSData?
        }
        
        let category3 = Category(context: context)
        category3.name = "Desserts"
        if let image = UIImage(named: "desserts") {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category3.picture = data as NSData?
        }
        
        let category4 = Category(context: context)
        category4.name = "Fruits and Vegtables"
        if let image = UIImage(named: "fruitAndVegs") {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category4.picture = data as NSData?
        }
        
        let category5 = Category(context: context)
        category5.name = "Carbohydrates"
        if let image = UIImage(named: "carbs") {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category5.picture = data as NSData?
        }
        
        ad.saveContext()
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
