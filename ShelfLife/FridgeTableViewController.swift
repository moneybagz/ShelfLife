//
//  FridgeViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class FridgeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var tableView: UITableView!    
    @IBOutlet var leftBarButtonItem: UIBarButtonItem!
    
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
    
    // Properties for AVCapture Metadata Output Object Delegate
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var barCodeFrameView:UIView?
    var barCode:Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup left bar button item barcode
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "barcode"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.barcodeButtonPressed(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //testData()
        
        
        // WHY DOES THIS METHOD HAVE TO BE STATIC?
        fetchResultsController = DAO.getFoodItems()
        fetchResultsController.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
 
        
        // CELL NAME
        cell.foodItemLabel.text = foodItem.name
        // CELL COLOR
        if foodItem.isInKitchen == true {
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
        // CELL QUANTITY
        if foodItem.isInKitchen == true {
            cell.quantityLabel.text = "\(foodItem.quantity)" + "X"
        }
        else {
            cell.quantityLabel.text = ""
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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Add New Button
        let addAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Add New", handler: {(action,indexPath) -> Void in
            
            // get view controller to segue ready
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ExpDateViewController
            
            // fill new vc property with food item at selected index
            vc.foodItem = self.fetchResultsController.object(at: indexPath)
            
            // segue to ExpDateViewController
            self.present(vc, animated: true, completion: nil)
            
        })
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Remove", handler: {(action,indexPath) -> Void in
            
            let foodItem = self.fetchResultsController.object(at: indexPath)
            
            // If food Item is "in kitchen" transfer to "not in kitchen" section
            if foodItem.isInKitchen == true {
                
                // delete "in my kitchen" information
                foodItem.isInKitchen = false
                foodItem.boughtDate = nil
                foodItem.expDate = nil
                
                //delete user notification
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.cancelNotification(with: foodItem)
                
                //check if other foodItems with same name exist then delete
                let foodItems = self.fetchResultsController.fetchedObjects
                
                var counter:Int = 0
                for food in foodItems! {
                    if foodItem.name == food.name {
                        counter += 1
                    }
                }
                
                if counter > 1 {
                    context.delete(foodItem)
                }
                
                ad.saveContext()

                self.tableView.reloadData()
            }
            // If food item is "not in kitchen" then just delete it.
            else {
                // Delete the row from the tableview fetch Results Controller Delegate will handle the rest
                context.delete(foodItem)
                ad.saveContext()
            }
            
        })
        
        
        addAction.backgroundColor = UIColor(colorLiteralRed: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
//        deleteAction.backgroundColor = UIColor(colorLiteralRed: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, addAction]
    }
    
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
    
    // MARK: - UAVCapture Metadata Output Objects Delegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects == nil || metadataObjects.count == 0 {
            barCodeFrameView?.frame = .zero
            
            return
        }
        
        // Get the metadata object
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // If the found metadata is equal to the barcode metadata then update the set the bounds (Green Laser Thingy) save barcode and end session
        if metaDataObj.type == AVMetadataObjectTypeEAN13Code {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
            barCodeFrameView?.frame = barCodeObject!.bounds
            
            if metaDataObj.stringValue != nil {
                let barcodeString = metaDataObj.stringValue
                barCode = Int(barcodeString!)
                //print("!!!!!!!!!!!!!!!!EAN13 \(barCode) !!!!!!!!!!!!!!!!!!")
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForMatchingBarcode), userInfo: nil, repeats: false)
            }
        }
        
        if metaDataObj.type == AVMetadataObjectTypeEAN8Code {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
            barCodeFrameView?.frame = barCodeObject!.bounds
            
            if metaDataObj.stringValue != nil {
                let barcodeString = metaDataObj.stringValue
                barCode = Int(barcodeString!)
                //print("!!!!!!!!!!!!!!!! \(barCode) !!!!!!!!!!!!!!!!!!")
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForMatchingBarcode), userInfo: nil, repeats: false)
            }
        }
        
        //        if metaDataObj.type == AVMetadataObjectTypeUPCECode {
        //
        //            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
        //            barCodeFrameView?.frame = barCodeObject!.bounds
        //
        //            if metaDataObj.stringValue != nil {
        //                //messageLabel.text = metaDataObj.stringValue
        //                captureSession?.stopRunning()
        //            }
        //        }
    }
    
    func checkForMatchingBarcode () {
        
        if let foodItems = fetchResultsController.fetchedObjects {
            
            // Loop through all food items to find matching barcode
            for foodItem in foodItems {
                if foodItem.barcode == Int64(barCode!) {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ExpDateViewController
                    vc.foodItem = foodItem
                    //let vc = ExpDateViewController()
                    self.present(vc, animated: true, completion: nil)
                    return
                }
            }
            // If no matching barcode is found send alert message
            let alertController = UIAlertController(title: "CANNOT SAVE", message: "you have not registered this barcode yet. Create new item and scan barcode", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        // If user has no food items in their database send alert message
        let alertController = UIAlertController(title: "CANNOT SAVE", message: "you must create your food items before scanning", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        return
    }
    
    

    // MARK: - Actions
    // For programmatic back button
    @IBAction func backAction(_ sender: UIButton) {
        
        // Turn off camera and scanner
        captureSession?.stopRunning()
        barCodeFrameView?.removeFromSuperview()
        videoPreviewLayer?.removeFromSuperlayer()
        
        // Setup left bar button item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "barcode"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.barcodeButtonPressed(_:)))
    }
    
    @IBAction func barcodeButtonPressed(_ sender: Any) {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(self.backAction(_:)))
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            // Set the input device on the capture captureSession
            captureSession?.addInput(input)
            
        } catch {
            print(error)
            return
        }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        //        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        barCodeFrameView = UIView()
        if let barCodeFrameView = barCodeFrameView {
            barCodeFrameView.layer.borderColor = UIColor.green.cgColor
            barCodeFrameView.layer.borderWidth = 2
            view.addSubview(barCodeFrameView)
            view.bringSubview(toFront: barCodeFrameView)
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
