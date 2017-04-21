//
//  RecipeCreatorViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/21/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class RecipeCreatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    
    var ingredients:[String] = []
    var quantities:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup text field delegates
        nameTextField.delegate = self
        ingredientTextField.delegate = self
        quantityTextField.delegate = self

        // Add UIToolBar on keyboard and Done button on UIToolBar
        self.addDoneButtonOnKeyboard()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCreatorTableViewCell
        
        cell.nameLabel.text = ingredients[indexPath.row]
        
        cell.quantityLabel.text = quantities[indexPath.row]
        
        return cell
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ingredientTextField.text != "" || ingredientTextField.text != nil {
            
            guard quantityTextField.text != nil || quantityTextField.text != nil else {
                
                let alertController = UIAlertController(title: "CANNOT ADD", message: "quantity must have a number", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                
                return
            }
            
            ingredients.append(ingredientTextField.text!)
            quantities.append(quantityTextField.text!)
            
            tableView.reloadData()
        }
    }
    
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RecipeCreatorViewController.doneButtonAction))
        
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
