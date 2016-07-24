//
//  SpecificCategoryTableViewController.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/11/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit
import CoreData


class SpecificCategoryTableViewController: UITableViewController, AddingNewItem, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext :NSManagedObjectContext!
    
    var fetchedResultsController :NSFetchedResultsController!
    
    var groceryCategory : NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = groceryCategory.valueForKey("title") as? String
       
        let fetchRequest = NSFetchRequest(entityName: "GroceryItem")
        let predicate = NSPredicate(format: "groceryCategory.title == %@", self.title!)
        fetchRequest.predicate = predicate

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
        self.fetchedResultsController.delegate = self
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == "SpecificCategoryTableViewControllerSegue" {
    
        }  else {

            guard let addItemViewController = segue.destinationViewController as? AddItemViewController
                else {
                    
                    fatalError("Destination controller not found")
            }
            
            addItemViewController.addingNewItemdelegate = self;
        }
    }

    
    func addNewItemDidSave(enteredItem: String) {
                
    let groceryItem = NSEntityDescription.insertNewObjectForEntityForName("GroceryItem", inManagedObjectContext: self.managedObjectContext)
        
        groceryItem.setValue(enteredItem, forKey: "title")

        let groceryItems = groceryCategory.mutableSetValueForKey("groceryItems")

        groceryItems.addObject(groceryItem)

        try! self.managedObjectContext.save()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("")
        }
       
        return sections[section].numberOfObjects
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryItemCell", forIndexPath: indexPath)
        
        guard let groceryItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as? GroceryItem else {
            fatalError("Error getting GroceryItem")
        }
        
        cell.textLabel?.text = groceryItem.title
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            print("Deleting the item!")
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath)
            self.managedObjectContext.deleteObject(item as! NSManagedObject)
           
            do {
                try self.managedObjectContext.save()
            } catch _ as NSError {
                print ("Can not delete the item!")
            }
            

            
            return
        }
    }


}
