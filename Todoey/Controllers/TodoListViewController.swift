//
//  ViewController.swift
//  Todoey
//
//  Created by Reimo on 1/25/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    
    // Constants here:
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{ // this method load when selectedCategory have a value.
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        title = selectedCategory!.name
        
        guard let colourHex = selectedCategory?.colour else{fatalError()}
            
         UpdateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        UpdateNavBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK:- NavBar Design Method.
    
    func UpdateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller dosen't exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else{fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }
    
    // MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
         
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row ) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }

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

    func loadItems () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    // MARK:- Delete Data From Swipe.
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("Error Deleting Item with Swipe")
            }
        }
    }
    
}

//MARK:- SearchBar Method

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    

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

