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
   // var foodInKitchen = [FoodItem]()
   // var foodNotInKitchen: [FoodItem] = []
    let headerTitles = ["In my kitchen", "Not in kitchen"]
    var fetchResultsController: NSFetchedResultsController<FoodItem>!
//    // help to show when section needs to be reinserted
//    var inMyKitchenSectionDeleted:Bool = false
//    var notInMyKitchenSectionDeleted:Bool = false
//    // these bools prevent reinserting section after section was just reinserted
//    var sectionOneReinsertedAfterZeroSections = false
//    var sectionTwoReinsertedAfterZeroSections = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        testData()
        
        
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
    
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchResultsController.sections {
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\(section)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as! FridgeTableViewCell
        
        let foodItem = fetchResultsController.object(at: indexPath)
        
        print(foodItem.name)
        
        
        
        // split FoodItems between two arrays for each section
        //foodItem.isInKitchen ? foodInKitchen.insert(foodItem, at: indexPath.row) : foodNotInKitchen.insert(foodItem, at: indexPath.row)
        
//        if indexPath.section == 0 {
//            // section 0 could have different values "in kitchen" / "not in kitchen"
//            if foodItem.isInKitchen == true {
//                foodInKitchen.append(foodItem)
//            }
//            else {
//                foodNotInKitchen.append(foodItem)
//            }
//        }
//        else {
//            foodNotInKitchen.append(foodItem)
//        }
        
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

//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: {(action,indexPath) -> Void in
//            
////            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
////            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
////                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
////                self.present(activityController, animated: true, completion: nil)
////            }
//        })
//        
//        // Delete button
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action,indexPath) -> Void in
//            
//            // Delete the row from the tableview fetch Results Controller Delegate will handle the rest
//            let foodItem = self.fetchResultsController.object(at: indexPath)
//            context.delete(foodItem)
//            ad.saveContext()
//        })
//        
//        
////        shareAction.backgroundColor = UIColor(colorLiteralRed: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
////        deleteAction.backgroundColor = UIColor(colorLiteralRed: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
//        
//        return [deleteAction]
//    }
    
    // MARK: - Fetch Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case.insert:
            if let indexPath = newIndexPath {
//                
//                print("&&&&&&&&&&&&&&&&&&&&&&&&&\(tableView.numberOfRows(inSection: indexPath.section))****************")
//                
//                // Insert correct section if section is missing then row
//                if inMyKitchenSectionDeleted == true && notInMyKitchenSectionDeleted == false {
//                    
//                    tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                    tableView.insertRows(at: [indexPath], with: .fade)
//                    inMyKitchenSectionDeleted = false
//                    break
//                }
//                    
//                else if inMyKitchenSectionDeleted == false && notInMyKitchenSectionDeleted == true {
//                
//                    
//                    tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                    tableView.insertRows(at: [indexPath], with: .fade)
//                    notInMyKitchenSectionDeleted = false
//                    break
//                }
//                else if inMyKitchenSectionDeleted == true && notInMyKitchenSectionDeleted == true {
//                    
//                    //                    let foodItem = fetchResultsController.object(at: indexPath)
//                    //                    if foodItem.isInKitchen == true {
//                    
//                    tableView.insertSections(IndexSet(integer: 0), with: .fade)
//                    tableView.insertRows(at: [indexPath], with: .fade)
//                    
//                    // find out which section is back and set bool
//                    let foodItem = fetchResultsController.object(at: indexPath)
//                    
//                    if foodItem.isInKitchen == true {
//                        inMyKitchenSectionDeleted = false
//                    }
//                    else {
//                        notInMyKitchenSectionDeleted = false
//                    }
//                    break
//                    //                    }
//                    //                    else {
//                    //
//                    //                        tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                    //                        tableView.insertRows(at: [indexPath], with: .fade)
//                    //                        notInMyKitchenSectionDeleted = false
//                    //                        break
//                    //                    }
//                }
            
            
  
                
                // Insert jsut row
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            
//                let rows = tableView.numberOfRows(inSection: indexPath.section)
//                print("&&&&&&&&&&&&&&&\(rows)@@@@@@@@@@@@@")
//                if tableView.numberOfRows(inSection: indexPath.section) > 1 {
//                    if tableView.headerView(forSection: indexPath.section)?.textLabel?.text == "In my kitchen" {
//                        
//                        tableView.insertSections(IndexSet(integer: 0), with: .fade)
//                        tableView.insertRows(at: [indexPath], with: .fade)
//                        
//                        break
//                    }
//                    else {
//                        
//                        tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                        tableView.insertRows(at: [indexPath], with: .fade)
//                        
//                        break
//                    }
//                }
//                tableView.insertRows(at: [indexPath], with: .fade)
//                
//                break
//            }
            
//            // Cell for row is after this so no need to add foodItem to VC arrays
//            // Insert just row? or insert secton then row
//            if let indexPath = newIndexPath {
//                
//                // Get food item to bool
//                let foodItem = fetchResultsController.object(at: indexPath)
//                // Are there 0 sections ?
//                if let sections = fetchResultsController.sections {
//                    // If there is one section figure out if section for foodItem exists or not. If not create it before inserting row
//                    if sections.count == 1 {
//                        if tableView.headerView(forSection: 0)?.textLabel?.text == "In my kitchen" {
//                            if foodItem.isInKitchen == false {
//                                tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                                tableView.insertRows(at: [indexPath], with: .fade)
//                               
//                                break
//                                
//                            }
//                            else {
//                                tableView.insertRows(at: [indexPath], with: .fade)
//                       
//                                break
//                                
//                            }
//                        }
//                        else {
//                            if foodItem.isInKitchen == true {
//                                tableView.insertSections(IndexSet(integer: 1), with: .fade)
//                                tableView.insertRows(at: [indexPath], with: .fade)
//                           
//                                break
//                                
//                            }
//                            else {
//                                tableView.insertRows(at: [indexPath], with: .fade)
//                                
////                                foodItem.isInKitchen ? foodInKitchen.insert(foodItem, at: indexPath.row) : foodNotInKitchen.insert(foodItem, at: indexPath.row)
//                                
//                                break
//                                
//                            }
//                        }
//                    }
//                    // If there are two sections insertion is simple
//                    else if sections.count == 2 {
//                        tableView.insertRows(at: [indexPath], with: .fade)
//                        
//                        break
//                        
//                    }
//                }
//                // if there are no sections, create section before insertion
//                else {
//                    tableView.insertSections(IndexSet(integer: 0), with: .fade)
//                    tableView.insertRows(at: [indexPath], with: .fade)
//
//                    break
//                }
//            }
            
                
//            if let indexPath = newIndexPath {
//
//                tableView.insertRows(at: [indexPath], with: .fade)
//                if indexPath.section == 0 {
//                    if tableView.headerView(forSection: 0)?.textLabel?.text == "In my kitchen" {
//                        let foodItem = fetchResultsController.object(at: indexPath)
//                        foodInKitchen.insert(foodItem, at: indexPath.row)
//                    }
//                    else {
//                        let foodItem = fetchResultsController.object(at: indexPath)
//                        foodNotInKitchen.insert(foodItem, at: indexPath.row)
//                    }
//                }
//                else {
//                    let foodItem = fetchResultsController.object(at: indexPath)
//                    foodNotInKitchen.insert(foodItem, at: indexPath.row)
//                }
//            }
 
        
//            if let indexPath = newIndexPath {
//                tableView.insertRows(at: [indexPath], with: .fade)
//                if indexPath.section == 0 {
//                    let foodItem = fetchResultsController.object(at: indexPath)
//                    foodInKitchen.insert(foodItem, at: indexPath.row)
//                }
//                else {
//                    let foodItem = fetchResultsController.object(at: indexPath)
//                    foodNotInKitchen.insert(foodItem, at: indexPath.row)
//                }
//            }
        case.delete:
            if let indexPath = indexPath {
//                let section = indexPath.section
//                
//                if tableView.numberOfRows(inSection: section) == 1 {
//                    if tableView.headerView(forSection: section)?.textLabel?.text == "In my kitchen" || inMyKitchenSectionDeleted == true {
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//                        tableView.deleteSections(IndexSet(integer: 0), with: .fade)
//                        inMyKitchenSectionDeleted = true
//                        
//                        break
//                    }
//                    else {
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//                        tableView.deleteSections(IndexSet(integer: 1), with: .fade)
//                        notInMyKitchenSectionDeleted = true
//                        
//                        break
//                    }
//
//                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
//                //Empty VC arrays (will be refilled during "cell for row" method)
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                if indexPath.section == 0 {
//                    if tableView.headerView(forSection: 0)?.textLabel?.text == "In my kitchen" {
//                        // Remove section if array count will go to zero
////                        print("^^^^^^^^^^^^^\(foodInKitchen.count)")
//                        
//                        if tableView.numberOfRows(inSection: 0) == 1 {
//                            tableView.deleteSections(IndexSet(integer: 0), with: .fade)
//                        }
//                        // Update array properties so correct property is segued
//                        foodInKitchen.remove(at: indexPath.row)
//                        
//                        break
//                    }
//                    else {
//                        if foodNotInKitchen.count == 1 {
//                            tableView.deleteSections(IndexSet(integer: 0), with: .fade)
//                        }
//                        foodNotInKitchen.remove(at: indexPath.row)
//                        
//                        break
//                    }
//                }
//                else {
//                    if foodNotInKitchen.count == 1 {
//                        tableView.deleteSections(IndexSet(integer: 1), with: .fade)
//                    }
//                    foodNotInKitchen.remove(at: indexPath.row)
//                    
//                    break
//                }
//            }
        
//            if let indexPath = indexPath {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                if indexPath.section == 0 {
//                    foodInKitchen.remove(at: indexPath.row)
//                    for food in foodInKitchen {
//                        print("\(food.name)")
//                    }
//                }
//                else {
//                    if foodNotInKitchen.count == 1 {
//                        tableView.deleteSections(IndexSet(integer: 1), with: .fade)
//                    }
//                    foodNotInKitchen.remove(at: indexPath.row)
//                }
//            }
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
                    destinationVC.foodItem = fetchResultsController.object(at: index)
                }
            }
            else {
                let destinationVC = segue.destination as! FoodItemViewController
                if let index = tableView.indexPathForSelectedRow {
                    destinationVC.nameColor = UIColor.black
                    destinationVC.foodItem = fetchResultsController.object(at: index)
                }
            }
        }
    }
 

}
