//
//  CoreDataManager.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/20/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    var managedObjectContext :NSManagedObjectContext!
    
    override init() {
        
        guard let url = NSBundle.mainBundle().URLForResource("GroceryListAppModel", withExtension: "momd") else {
            fatalError("GroceryAppModel not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: url) else {
            fatalError("ManagedObjectModel does not exist")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = NSFileManager()
        
        guard let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else {
            fatalError("Documents Directory does not exist")
        }
        
        print(documentsURL)
        
        let storeURL = documentsURL.URLByAppendingPathComponent("GroceryAppDatabase.sqlite")
        
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        
        let type = NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
    }
    
}
