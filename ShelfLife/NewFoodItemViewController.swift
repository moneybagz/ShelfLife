//
//  NewFoodItemViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class NewFoodItemViewController: UIViewController, NSFetchedResultsControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var foodCategoryPicker: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var inFridgeSegmentControl: UISegmentedControl!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expDatePicker: UIDatePicker!
    @IBOutlet var foodImageView: UIImageView!
    
    
    var categories:[Category]?
    var categoryName:String?
    var fetchResultsController: NSFetchedResultsController<Category>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide until "in Fridge" is selected
        quantityTextField.isHidden = true
        expDatePicker.isHidden = true
        
        // Setup PickerView 
        foodCategoryPicker.dataSource = self
        foodCategoryPicker.delegate = self

        // Fetch the category names for the UIPikckerView
        fetchResultsController = DAO.getCategories()
        fetchResultsController.delegate = self
        
        categories = fetchResultsController.fetchedObjects!
        categoryName = categories?.first?.name
        
        // Default image for food item is its Category Image
        if let foodImage = UIImage(data: categories?.first?.picture as! Data) {
            foodImageView.image = foodImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func editImage(_ sender: Any) {
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch inFridgeSegmentControl.selectedSegmentIndex
        {
        case 0:
            NSLog("Popular selected")
            quantityTextField.isHidden = true
            expDatePicker.isHidden = true
        case 1:
            NSLog("History selected")
            quantityTextField.isHidden = false
            expDatePicker.isHidden = false
        default:
            break;
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    // MARK: - PickerView Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categories != nil {
            return categories!.count
        }
        return 0
    }
    
    // MARK: - PickerView  Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryName = categories?[row].name
        print(categoryName!)
        
        if let foodImage = UIImage(data: categories?[row].picture as! Data) {
            foodImageView.image = foodImage
        }
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
