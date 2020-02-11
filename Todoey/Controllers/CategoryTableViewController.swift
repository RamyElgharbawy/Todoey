//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Reimo on 2/7/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Add Yet"
// It's mean if the categories not nil display the name of the indexpath.row in categories and if it is nil display this defult value.
        
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

    //MARK: - Add New Categories.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // this will happen once user clicked on add button (+).
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
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
