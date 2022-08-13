//
//  TodoListViewController.swift
//  Todoit
//
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //Create NSData Storage Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

//MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white //NOTE forced dark mode
        
        let item = itemArray[indexPath.row]
        
        //NOTE set to check otherwise set to none - terenary operator ==>
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
//MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        // NOTE delete items call then save context "try context.save()"

        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        itemArray[indexPath.row].setValue("Complete", forKey: "title")
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//MARK - Add Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoit Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "create new item"
            textField = alerTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }

        self.tableView.reloadData()
    }
    
    //NOTE: uses internal and external params with a default
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
  
    
}

//MARK - SearchBar Delegate methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        reloadSearch(with: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            reloadSearch(with: searchBar)
        }
    }
    
    func reloadSearch(with searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)
    }

}
