//
//  ViewController.swift
//  Todoey
//
//  Created by Reimo on 1/25/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // Constants here:
    
    var itemArray = [Item]()
    
    let defults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title="first item"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title="second item"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title="third item"
        itemArray.append(newItem3)
        
        
         // To update itemArray with the array in plist file
        
        if let  items=defults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray=items
        }
        
    }
    
     //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row] // to store this value insted of hard typing
        
        cell.textLabel?.text = item.title
        
        // To make check mark for selected cell :>>>>>
        
        // Ternary Operator:
        // Value = Condition ? Value If True : Value If False
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // To make selected row flash and animated:
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Add UIAlert controller
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // That will happen once the user clicks add item button in UIAlert
            
            let newItem=Item()
            newItem.title=textField.text!
            
            self.itemArray.append(newItem)
            
            self.defults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
            
        }
        // Add textField in alert controller
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder="Creat New Item"
            textField=alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

