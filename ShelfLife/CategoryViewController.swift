//
//  CategoryViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 3/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet var tableView: UITableView!
    
    
    var categories: [String] = []
    var fetchResultsController: NSFetchedResultsController<Category>!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchResultsController = DAO.getCategories()
        fetchResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = fetchResultsController.fetchedObjects
        if let results = results {
            return results.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as! CategoryTableViewCell
        
        let category = fetchResultsController.object(at: indexPath)
        

        
        cell.nameLabel.text = category.name
        cell.categoryImageView.image = UIImage(data: category.picture as! Data)
        
        return cell
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
