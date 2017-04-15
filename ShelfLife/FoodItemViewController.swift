//
//  FoodItemViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/1/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class FoodItemViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var boughtDateLabel: UILabel!
    @IBOutlet var expDateLabel: UILabel!
    @IBOutlet var freshBarImageView: UIImageView!
    
    
    var foodItem:FoodItem!
    var nameColor:UIColor!
    var freshCodeLine:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // No old meter readings
        freshCodeLine?.removeFromSuperview()
        
        // Fresh Color
        nameLabel.textColor = nameColor
        
        // Set name and possible image
        nameLabel.text = foodItem.name
        if let data = foodItem.picture {
            foodImageView.image = UIImage(data: data as Data)
        }
        
        // Format date to a string so it can be displayed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let boughtDate = foodItem.boughtDate {
            let boughtDateString = dateFormatter.string(from: boughtDate as Date)
            boughtDateLabel.text = boughtDateString
        }
        else {
            boughtDateLabel.text = "Not Available"
        }
        if let expDate = foodItem.expDate {
            let expDateString = dateFormatter.string(from: expDate as Date)
            expDateLabel.text = expDateString
        }
        else {
            expDateLabel.text = "Not available"
        }
        
        //Get FreshBar meter reading
        if foodItem.boughtDate != nil && foodItem.expDate != nil {
            freshBarMeter()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom methods
    
    func freshBarMeter() {
        
        // Get total time between bought date and expiration date
        let totalTime = foodItem.expDate?.timeIntervalSince(foodItem.boughtDate as! Date)
        
        // Get elapsed time between now and bought date
        let now = Date()
        let elapsedTime = now.timeIntervalSince(foodItem.boughtDate as! Date)
        
        // Compute the increase percentage
        let percent:Int
        let percentage = (elapsedTime) / (totalTime)! * 100
        percent = Int(percentage)
        
        // create meter reading view line
        if percent >= 100 {
            freshCodeLine = UIView(frame: CGRect(x: 240, y: 0, width: 3, height: 46))
            freshCodeLine?.backgroundColor = UIColor.black
            freshBarImageView.addSubview(freshCodeLine!)
            freshBarImageView.bringSubview(toFront: foodImageView)
        }
        else {
            freshCodeLine = UIView(frame: CGRect(x: percent * 2 + 14, y: 0, width: 3, height: 46))
            freshCodeLine?.backgroundColor = UIColor.black
            freshBarImageView.addSubview(freshCodeLine!)
            freshBarImageView.bringSubview(toFront: foodImageView)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditFoodItem" {
            let editVC = segue.destination as! NewFoodItemViewController
            editVC.foodItemToEdit = foodItem
        }
    }
    

}
