//
//  CategoryTableViewController.swift
//  Todoit
//
//  Created by Luke on 8/13/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none

        navigationController?.navigationBar.tintColor = UIColor.flatWhite()
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No categories added yet"
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "525e75")
            cell.textLabel?.textColor = UIColor.flatWhite()
        }
        
        
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
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories  = realm.objects(Category.self)
           
        tableView.reloadData()
    }
    
    //MARK - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
        
    }
    
    //MARK - Add category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
     
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.init(randomFlatColorOf: .dark).hexValue()
            
            self.save(category: newCategory)

            //            Cotton candy: #ff595e, #ffca3a, #8ac926, #1982c4 and #6a4c93.
            //            Forest: #f1ddbf, #525e75, #78938a and #92ba92.
        }
            
        alert.addAction(action)
        
        alert.addTextField() { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }

}
