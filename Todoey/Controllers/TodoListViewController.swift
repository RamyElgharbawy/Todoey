//
//  ViewController.swift
//  Todoey
//
//  Created by Reimo on 1/25/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // Constants here:
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{ // this method load when selectedCategory have a value.
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]// to store this value insted of hard typing
        {
            cell.textLabel?.text = item.title
            
            // To make check mark for selected cell :>>>>>
            
            // Ternary Operator:
            // Value = Condition ? Value If True : Value If False
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status ,\(error)")
            }
        }
        
           tableView.reloadData()
        
     //   todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        // context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
       
    //     saveItems()
        
        // To make selected row flash and animated:
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Add UIAlert controller
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // That will happen once the user clicks add item button in UIAlert.
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title=textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new item ,\(error)")
                }
            }
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
    
    // MARK: - DataBase Methods

//    func saveItems(){
//
//        do {
//            try context.save()
//        }catch{
//            print("Error saving context,\(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    // Load data methode:
    
    // This is a func have 2 parameter 1- is the requset and his defult value , 2- is the predicate and his defult value.
    func loadItems () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

//MARK:- SearchBar Method

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    
//    // 1- creat a request to load the data from container.
//    let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//    // 2- Creat a predicate to manege the search options and Add it to the request.
//    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//    // 3- Sort the search result by using sortDescriptor and Add it to the request.
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//    
//    // 4- load the data from context in container.
//
//    loadItems(with: request,predicate: predicate)

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // this will happen when user delete search keyword.

            loadItems()

            // Dismiss the keyboard and searchBar curoser.

            DispatchQueue.main.async { // to add this method to main thread.
                searchBar.resignFirstResponder()  // to load defult setting of searchBar.
            }
        }
    }

}

