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
    
    
    var categories:[String] = []
    var category:String?
    var fetchResultsController: NSFetchedResultsController<Category>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup PickerView 
        foodCategoryPicker.dataSource = self
        foodCategoryPicker.delegate = self

        // Fetch the category names for the UIPikckerView
        fetchResultsController = DAO.getCategories()
        fetchResultsController.delegate = self
        
        let results = fetchResultsController.fetchedObjects
        category = results?.first?.name
        for result in results! {
            categories.append(result.name!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    // MARK: - PickerView Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // MARK: - PickerView  Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
        print(category)
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
