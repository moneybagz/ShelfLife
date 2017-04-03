//
//  CategoryTableViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/2/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var foodItems = [FoodItem]()
    var foodInKitchen = [FoodItem]()
    var foodNotInKitchen = [FoodItem]()
    let headerTitles = ["In my kitchen", "Not in kitchen"]
    var fetchResultsController: NSFetchedResultsController<FoodItem>!
    var category: Category!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableView delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // register Xib cell
        // reminder if you are going to use the same cell twice for more than one view controller, better to use a xib
        let nib = UINib(nibName: "FoodItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "foodCell")
        
        // WHY DOES THIS METHOD HAVE TO BE STATIC?
        fetchResultsController = DAO.getFoodItemsFor(category: category)
        fetchResultsController.delegate = self
                
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section 0 could have 2 different values "in kitchen"/ "not in kitchen"
        if section == 0 {
            if let foodItems = fetchResultsController.fetchedObjects {
                let foodItem = foodItems.first
                
                if foodItem?.isInKitchen == true {
                    return headerTitles[0]
                }
                else {
                    return headerTitles[1]
                }
            }
        }
            // secton 1 can only have 1 value "not in kitchen"
        else if section == 1 {
            return headerTitles[1]
        }
        
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodItemTableViewCell
        
        let foodItem = fetchResultsController.object(at: indexPath)
        
        // split FoodItems between two arrays for each section
        if indexPath.section == 0 {
            // section 0 could have different values "in kitchen" / "not in kitchen"
            if foodItem.isInKitchen == true {
                foodInKitchen.append(foodItem)
            }
            else {
                foodNotInKitchen.append(foodItem)
            }
        }
        else {
            foodNotInKitchen.append(foodItem)
        }
        
        // CELL NAME
        cell.foodNameLabel.text = foodItem.name
        // CELL COLOR
        if foodItem.boughtDate != nil && foodItem.expDate != nil {
            cell.foodNameLabel.textColor = getFreshnessWith(foodItem: foodItem)
        }
        else {
            cell.foodNameLabel.textColor = UIColor.black
        }
        // CELL PICTURE
        if let data = foodItem.picture {
            cell.foodImageView.image = UIImage(data: data as Data)
        }
        else {
            cell.foodImageView.image = nil
        }
        
        return cell
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
                if indexPath.section == 0 {
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
            if tableView.headerView(forSection: 0)?.textLabel?.text == "In my kitchen" {
                let destinationVC = segue.destination as! FoodItemViewController
                if let index = tableView.indexPathForSelectedRow {
                    let cell = tableView.cellForRow(at: index) as! FridgeTableViewCell
                    destinationVC.nameColor = cell.foodItemLabel.textColor
                    destinationVC.foodItem = foodInKitchen[index.row]
                }
            }
//            if tableView.indexPathForSelectedRow?.section == 0 {
//                
//            }
            else {
                let destinationVC = segue.destination as! FoodItemViewController
                if let index = tableView.indexPathForSelectedRow {
                    destinationVC.nameColor = UIColor.black
                    destinationVC.foodItem = foodNotInKitchen[index.row]
                }
            }
        }
        // send category property to edit
        else if segue.identifier == "toEditCategory" {
            let destinationVC = segue.destination as! NewCategoryViewController
            destinationVC.categoryToEdit = category
        }
    }

}
