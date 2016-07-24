//
//  AddItemViewController.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/11/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit

protocol AddingNewItem : class {
    
    func addNewItemDidSave(enteredItem: String)
    
}

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    weak var addingNewItemdelegate:AddingNewItem!

    @IBOutlet weak var groceryItemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groceryItemTextField.delegate = self
        
    }
  
    @IBAction func close(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save(sender: AnyObject) {

        let enteredItem = self.groceryItemTextField.text
        
        self.addingNewItemdelegate.addNewItemDidSave(enteredItem!)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
 
}
