//
//  ExpDateViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/4/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class ExpDateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var expDatePicker: UIDatePicker!
    @IBOutlet var quantityTextField: UITextField!
    
    var foodItem:FoodItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add UIToolBar on keyboard and Done button on UIToolBar
        self.addDoneButtonOnKeyboard()
        
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
        let cal: Calendar = Calendar(identifier: .gregorian)
        
        let expDateAM: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: expDate)!
        
        foodItemToSave.expDate = expDateAM as NSDate
        // QUANTITY
        if quantityTextField.text == nil || quantityTextField.text == "" {
            foodItemToSave.quantity = 1
        }
        else {
            foodItemToSave.quantity = Int16(quantityTextField.text!)!
        }
        
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
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // custom method for putting a done button on number pad
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NewFoodItemViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.quantityTextField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.quantityTextField.resignFirstResponder()
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
