//
//  AddCategoryViewController.swift
//  Grocery_App_Swift
//
//  Created by Toleen Jaradat on 7/11/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit

protocol AddingNewCategory: class {
    
    func addNewCategoryDidSave(enteredCategory: String)
}


class AddCategoryViewController: UIViewController, UITextFieldDelegate {

    weak var addingNewCategorydelegate:AddingNewCategory!

    @IBOutlet weak var groceryCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groceryCategoryTextField.delegate = self
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save(sender: AnyObject) {
        
        let enteredCategory = self.groceryCategoryTextField.text
        
        self.addingNewCategorydelegate.addNewCategoryDidSave(enteredCategory!)
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
