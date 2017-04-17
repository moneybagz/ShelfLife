//
//  ExpDateViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/4/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class ExpDateViewController: UIViewController {

    @IBOutlet var expDatePicker: UIDatePicker!
    
    var foodItem:FoodItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Date Picker
        expDatePicker.minimumDate = Date()
        var components = DateComponents()
        components.setValue(20, for: .year)
        let date: Date = Date()
        expDatePicker.maximumDate = Calendar.current.date(byAdding: components, to: date)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let date = Date()
        let units: Set<Calendar.Component> = [.day, .month, .year]
        let components = Calendar.current.dateComponents(units, from: date)
        
        // Components for exp date
        let expDate = expDatePicker.date
        let expComponents = Calendar.current.dateComponents(units, from: expDate)
        guard components != expComponents else {
            
            let alertController = UIAlertController(title: "CANNOT SAVE", message: "bought date cannot be the same as expiration date", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let foodItemToSave = FoodItem(context: context)
        
        // UUID
        foodItemToSave.uuid = UUID().uuidString
        // NAME
        foodItemToSave.name = foodItem.name
        // CATEGORY
        foodItemToSave.toCategory = foodItem.toCategory
        // IMAGE
        foodItemToSave.picture = foodItem.picture
        // BARCODE
        foodItemToSave.barcode = foodItem.barcode
        // IsInKITCHEN BOOL
        foodItemToSave.isInKitchen = true
        // BOUGHT DATE
        foodItemToSave.boughtDate = Date() as NSDate?
        // EXP DATE
        foodItemToSave.expDate = expDate as NSDate
        // QUANTITY
        foodItemToSave.quantity = foodItem.quantity
        
        //USER NOTIFICATION
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(with: foodItemToSave)
        
        
        // Delete "not in kitchen" item when creating a new one
        if foodItem.isInKitchen == false {
            context.delete(foodItem)
        }

        ad.saveContext()
        self.dismiss(animated: true, completion: nil)
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
