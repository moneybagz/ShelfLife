//
//  NewFoodItemViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class NewFoodItemViewController: UIViewController, NSFetchedResultsControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet var foodCategoryPicker: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var isBoughtSegmentControl: UISegmentedControl!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expDatePicker: UIDatePicker!
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var barcodeLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    
    
    var categories:[Category]?
    var categoryName:String?
    var imageIsEdited = false
    var fetchResultsController: NSFetchedResultsController<Category>!
    
    // Properties for AVCapture Metadata Output Object Delegate
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var barCodeFrameView:UIView?
    var barCode:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide until scanned
        barcodeLabel.isHidden = true
        
        // Hide until "in Fridge" is selected
        quantityTextField.isHidden = true
        expDatePicker.isHidden = true
        quantityLabel.isHidden = true
        
        // Configure Date Picker
        expDatePicker.minimumDate = Date()
        var components = DateComponents()
        components.setValue(20, for: .year)
        let date: Date = Date()
        expDatePicker.maximumDate = Calendar.current.date(byAdding: components, to: date)
        
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
    
    @IBAction func scanBarCodePressed(_ sender: Any) {
        
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
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
    }
    
    @IBAction func segmentIndexChanged(_ sender: Any) {
        switch isBoughtSegmentControl.selectedSegmentIndex
        {
        case 0:
            // if item is not bought hide exp date and quantity
            quantityTextField.isHidden = true
            expDatePicker.isHidden = true
            quantityLabel.isHidden = true
        case 1:
            quantityTextField.isHidden = false
            expDatePicker.isHidden = false
            quantityLabel.isHidden = false
        default:
            break;
        }
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // If user does not give food item a name give alert message
//        guard nameTextField.text != nil && nameTextField.text != "" else {
//            
//            let alertController = UIAlertController(title: "CANNOT SAVE", message: "food item must have a name", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
//            alertController.addAction(okAction)
//            present(alertController, animated: true, completion: nil)
//            
//            return
//        }
        
        // If user does not change exp date give alert message
        if isBoughtSegmentControl.selectedSegmentIndex == 1 {
            // Compare Bought date to exp date, make sure they are different
            // Components for Bought date
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
            
            // User cannot leave quantity textfield without number
            if quantityTextField.text == "" {
                quantityTextField.text = "1"
            }
        }
        
        // Build a NSManaged Object FoodItem
        let foodItem = FoodItem(context: context)
        
        // NAME
        foodItem.name = "poo"//nameTextField.text
        // CATEGORY
        foodItem.toCategory = categories?[foodCategoryPicker.selectedRow(inComponent: 0)]
        // IMAGE
        if let image = foodImageView.image {
            let data = UIImageJPEGRepresentation(image, 1.0)
            foodItem.picture = data as NSData?
        }
        // BARCODE
        if let itemBarCode = barCode {
            foodItem.barcode = Int64(itemBarCode)
        }
        // IsInKITCHEN BOOL
        foodItem.isInKitchen = isBoughtSegmentControl.selectedSegmentIndex == 0 ? false : true
        if foodItem.isInKitchen == true {
            // BOUGHT DATE
            foodItem.boughtDate = Date() as NSDate?
            // EXP DATE
            foodItem.expDate = expDatePicker.date as NSDate?
            // QUANTITY
            foodItem.quantity = Int16(quantityTextField.text!)!
        }
        
        //save food item to coreData SQL database
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
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
                barcodeLabel.isHidden = false
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(removeBarCodeSession), userInfo: nil, repeats: false)
            }        }
        
        if metaDataObj.type == AVMetadataObjectTypeEAN8Code {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
            barCodeFrameView?.frame = barCodeObject!.bounds
            
            if metaDataObj.stringValue != nil {
                let barcodeString = metaDataObj.stringValue
                barCode = Int(barcodeString!)
                //print("!!!!!!!!!!!!!!!! \(barCode) !!!!!!!!!!!!!!!!!!")
                barcodeLabel.isHidden = false
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(removeBarCodeSession), userInfo: nil, repeats: false)
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
    
    func removeBarCodeSession() {
        captureSession?.stopRunning()
        barCodeFrameView?.removeFromSuperview()
        videoPreviewLayer?.removeFromSuperlayer()
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
        foodImageView.image = selectedImage
        
        // Change imageIsEdited Bool so categoryPicker can no longer change image
        imageIsEdited = true
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
        
        if imageIsEdited == false {
            if let foodImage = UIImage(data: categories?[row].picture as! Data) {
                foodImageView.image = foodImage
            }
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
