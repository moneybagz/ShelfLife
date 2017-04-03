//
//  NewCategoryViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/1/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    
    
    var categoryToEdit:Category?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If category is being edited
        if let category = categoryToEdit {
            if let data = category.picture {
                categoryImageView.image = UIImage(data: data as Data)
            }
            nameTextField.text = category.name
        }

        // setup text field delegate
        nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func addImage(_ sender: Any) {
        
        // Privacy settings in plist have been set for camera
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // allow photos to taken.
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePickerController.sourceType = .camera
        }
        else
        {
            imagePickerController.sourceType = .photoLibrary
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // If user does not give category a name give alert message
        guard nameTextField.text != nil && nameTextField.text != "" else {
            
            let alertController = UIAlertController(title: "CANNOT SAVE", message: "category must have a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        var category:Category!
        
        // Build a NSManaged Object Category unless user is editing
        if categoryToEdit == nil {
            category = Category(context: context)
        }
        else {
            category = categoryToEdit
        }
        
        // NAME
        category.name = nameTextField.text
        // IMAGE
        if let image = categoryImageView.image {
            let data = UIImageJPEGRepresentation(image, 1.0)
            category.picture = data as NSData?
        }
        
        
        //save category to coreData SQL database
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIImage Picker Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        categoryImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
