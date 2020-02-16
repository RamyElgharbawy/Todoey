//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Reimo on 2/7/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    // initalizing New Realm.
    
    let realm = try! Realm()
    
    // Constant Here.
    
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      loadCategories()
        
    }
    
    //MARK:- TableView DataSource Methods.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil Coalescing Operator->>>
        
        return categories?.count ?? 1 //<<<- That's Mean if the categories not nil return categories.count and if it Nil return 1 [defult value]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else{fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK:- TableView Delegate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods.
    
    func save (category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error Saving in realm , \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories (){
        
         categories = realm.objects(Category.self)

         tableView.reloadData()
    }
    
    //MARK:- Delete Data From Swipe.
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error Deleting Category")
            }
        }
    }

    //MARK: - Add New Categories.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // this will happen once user clicked on add button (+).
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save (category: newCategory)
        }
        
        // add textField in alert.
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

        
    }
    
}


