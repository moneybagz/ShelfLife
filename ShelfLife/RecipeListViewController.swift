//
//  RecipeListViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 5/27/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var fetchResultsController: NSFetchedResultsController<RecipeFoodItem>!
    var recipe: Recipe!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchResultsController = DAO.getRecipeList(recipe: recipe)
        
        fetchResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let results = fetchResultsController.fetchedObjects
        if let results = results {
            return results.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeList", for: indexPath) as! RecipeListTableViewCell
        
        let recipeFoodItem = fetchResultsController.fetchedObjects?[indexPath.row]
        
        cell.foodLabel.text = recipeFoodItem?.name
        cell.amountLabel.text = recipeFoodItem?.quantity
        
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
