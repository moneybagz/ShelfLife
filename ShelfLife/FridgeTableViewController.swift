//
//  FridgeViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class FridgeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    
    var foodItems = [FoodItem]()
    var foodInKitchen = [FoodItem]()
    var foodNotInKitchen = [FoodItem]()
    let headerTitles = ["In my kitchen", "Not in kitchen"]
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom methods
    
    func getFreshnessWith(foodItem: FoodItem) -> UIColor {
        
        // Get total time between bought date and expiration date
        let totalTime = foodItem.expDate?.timeIntervalSince(foodItem.boughtDate as! Date)
        
        // Get elapsed time between now and bought date
        let now = Date()
        let elapsedTime = now.timeIntervalSince(foodItem.boughtDate as! Date)
        
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
        
        // split FoodItems between two arrays for each section
        if indexPath.section == 0 {
            foodInKitchen.append(foodItem)
        }
        else {
            foodNotInKitchen.append(foodItem)
        }
        
        // CELL NAME
        cell.foodItemLabel.text = foodItem.name
        // CELL COLOR
        if foodItem.boughtDate != nil && foodItem.expDate != nil {
            cell.foodItemLabel.textColor = getFreshnessWith(foodItem: foodItem)
        }
        else {
            cell.foodItemLabel.textColor = UIColor.black
        }
        // CELL PICTURE
        if let data = foodItem.picture {
            cell.foodItemImage.image = UIImage(data: data as Data)
        }
        else {
            cell.foodItemImage.image = nil
        }
        
        return cell
    }
    
    
    func testData(){
        let foodItem1 = FoodItem(context: context)
        foodItem1.name = "cheese"
        foodItem1.isInKitchen = true
        
        let foodItem2 = FoodItem(context: context)
        foodItem2.name = "Pear"
        foodItem2.isInKitchen = false
        
        let foodItem3 = FoodItem(context: context)
        foodItem3.name = "Filet Mignon"
        foodItem3.boughtDate = Date() as NSDate
        foodItem3.isInKitchen = false
        
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
    
    // MARK: - Table view delegate methods
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let foodItem = fetchResultsController.object(at: indexPath)
            context.delete(foodItem)
            ad.saveContext()
        }
    }

    
    // MARK: - Fetch Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                if tableView.indexPathForSelectedRow?.section == 0 {
                    let foodItem = fetchResultsController.object(at: indexPath)
                    foodInKitchen.insert(foodItem, at: indexPath.row)
                }
                else {
                    let foodItem = fetchResultsController.object(at: indexPath)
                    foodNotInKitchen.insert(foodItem, at: indexPath.row)
                }
            }
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                if indexPath.section == 0 {
                    foodInKitchen.remove(at: indexPath.row)
                    for food in foodInKitchen {
                        print("\(food.name)")
                    }
                }
                else {
                    foodNotInKitchen.remove(at: indexPath.row)
                }
            }
        case.update:
            if let indexPath = indexPath {
                tableView.cellForRow(at: indexPath)
            }
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send selected FoodItem and fresh color to the next View Controller
        if segue.identifier == "toFoodItemVC" {
            if tableView.indexPathForSelectedRow?.section == 0 {
                let destinationVC = segue.destination as! FoodItemViewController
                if let index = tableView.indexPathForSelectedRow {
                    let cell = tableView.cellForRow(at: index) as! FridgeTableViewCell
                    destinationVC.nameColor = cell.foodItemLabel.textColor
                    destinationVC.foodItem = foodInKitchen[index.row]
                }
            }
            else {
                let destinationVC = segue.destination as! FoodItemViewController
                if let index = tableView.indexPathForSelectedRow {
                    destinationVC.nameColor = UIColor.black
                    destinationVC.foodItem = foodNotInKitchen[index.row]
                }
            }
        }
    }
 

}
