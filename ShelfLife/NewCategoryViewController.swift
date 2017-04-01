//
//  NewCategoryViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/1/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {
    
    
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImage(_ sender: Any) {
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
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
