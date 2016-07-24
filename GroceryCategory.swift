//
//  GroceryCategory.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/20/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit
import CoreData

class GroceryCategory: NSManagedObject {

    @NSManaged var title: String!
    @NSManaged var groceryItems: Set<GroceryItem>! 

}
