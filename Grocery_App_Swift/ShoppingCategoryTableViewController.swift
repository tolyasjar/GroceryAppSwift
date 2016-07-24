//
//  ShoppingCategoryTableViewController.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/11/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCategoryTableViewController: UITableViewController, AddingNewCategory, NSFetchedResultsControllerDelegate  {
    
    var managedObjectContext :NSManagedObjectContext!
    
    var fetchedResultsController :NSFetchedResultsController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        
        let fetchRequest = NSFetchRequest(entityName: "GroceryCategory")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()

      }
    
    override func viewDidAppear(animated: Bool) {
        
        let fetchRequest = NSFetchRequest(entityName: "GroceryCategory")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! self.fetchedResultsController.performFetch()

    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
            
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)

            break
            
        case .Update:
            break
            
        case .Move:
            break
            
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func addNewCategoryDidSave(enteredCategory: String) {
                
        guard let groceryCategory = NSEntityDescription.insertNewObjectForEntityForName("GroceryCategory", inManagedObjectContext: self.managedObjectContext) as? GroceryCategory else {
            fatalError("GroceryCategory does not exist")
        }
        
        groceryCategory.title = enteredCategory
        
        try! self.managedObjectContext.save()
        

        
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    if segue.identifier == "AddCategoryViewControllerSegue"
    {
        guard let addCategoryViewController = segue.destinationViewController as? AddCategoryViewController
            else {
                fatalError("Destination controller not found")
        }
        
        addCategoryViewController.addingNewCategorydelegate = self;
        
    }
    else if  segue.identifier == "SpecificCategoryTableViewControllerSegue"
    {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Invalid IndexPath")
        }
        
        let groceryCategory = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        
        guard let specificCategoryTableViewController = segue.destinationViewController as? SpecificCategoryTableViewController else {
            fatalError("Destination controller not found")
        }
        
        specificCategoryTableViewController.groceryCategory = groceryCategory
        specificCategoryTableViewController.managedObjectContext = self.managedObjectContext
        
        }
    
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(ableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("Error")
        }
        
        return sections[section].numberOfObjects

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCategoryCell", forIndexPath: indexPath)
        
        guard let groceryCategory = self.fetchedResultsController.objectAtIndexPath(indexPath) as? GroceryCategory else {
            fatalError("Error getting GroceryCategory")
        }
        
        cell.textLabel?.text = groceryCategory.title
        if (groceryCategory.groceryItems.count > 0){
        
        cell.detailTextLabel?.text = String (groceryCategory.groceryItems.count)
        } else {
        cell.detailTextLabel?.text = " "

        }
        
        return cell
       
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            print("Deleting the Category!")
            let category = self.fetchedResultsController.objectAtIndexPath(indexPath)
            
            self.managedObjectContext.deleteObject(category as! NSManagedObject)
            
            do {
            try self.managedObjectContext.save()
            } catch _ as NSError {
                print ("Can not delete the category!")
            }

            return
        }
    }


 
}
