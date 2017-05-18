//
//  RecipeTableViewController.swift
//  ShelfLife
//
//  Created by Clyfford Millet on 4/20/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit
import CoreData


class RecipeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var recipes = [Recipe]()
    var fetchResultsController: NSFetchedResultsController<Recipe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchResultsController = DAO.getRecipes()
        recipes = fetchResultsController.fetchedObjects!
        
        fetchResultsController.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = fetchResultsController.fetchedObjects?[indexPath.row]
        
        cell.recipeNameLabel.text = recipe?.name
        
        return cell
    }
    
    // MARK: - Fetch Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case.update:
            if let indexPath = indexPath {
                tableView.cellForRow(at: indexPath)
            }
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
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
