//
//  CategoryTableViewController.swift
//  Todoit
//
//  Created by Luke on 8/13/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import Realm
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm() //a safe way to use ! declaration
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        cell.textLabel?.textColor = UIColor.white //NOTE forced dark mode
        
        return cell
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK - Data manipulation

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        let categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK - Add category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
     
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
            
        alert.addAction(action)
        
        alert.addTextField() { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }

}

