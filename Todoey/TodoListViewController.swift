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
    
    var itemArray = ["first item","second item","third item"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
     //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        // To make check mark for selected cell :>>>>>
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            self.itemArray.append(textField.text!)
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

