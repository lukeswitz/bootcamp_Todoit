//
//  TodoListViewController.swift
//  Todoit
//
//

import UIKit
import Realm
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    //if set, go ahead
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

//MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = todoItems?[indexPath.row].title
            cell.textLabel?.textColor = UIColor.white //NOTE forced dark mode
            //NOTE set to check otherwise set to none - terenary operator ==>
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
    
        return cell
    }
    
//MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done

        // NOTE delete items call then save context "try context.save()"
        //        context.delete(todoItems[indexPath.row])
        //        todoItems.remove(at: indexPath.row)

        //        todoItems[indexPath.row].setValue("Complete", forKey: "title")
        
        //saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//MARK - Add Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoit Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                           let newItem = Item()
                           newItem.title = textField.text!
                           currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "create new item"
            textField = alerTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
   }
  
}

////MARK - SearchBar Delegate methods
//
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        } else {
//            reloadSearch(with: searchBar)
//        }
//    }
//
//    func reloadSearch(with searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//    }
//
//}
