//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 18.08.2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [CellItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentItem = self.itemArray[indexPath.row]
        
        currentItem.done = !(currentItem.done)
        tableView.cellForRow(at: indexPath)?.accessoryType = currentItem.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.context.delete(currentItem)
//        self.itemArray.remove(at: indexPath.row)
        
        self.saveItems()
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoye Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add item button
            if let text = textField.text, text.count > 0 {
                
                let newItem = CellItem(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.tableView.reloadData()
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        
        do {
            try context.save()
            self.tableView.reloadData()
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        
    }
    
    func loadItems() {

        let request : NSFetchRequest<CellItem> = CellItem.fetchRequest()
        do {
            self.itemArray = try self.context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error loading context \(error.localizedDescription)")
        }
        
    }
    

}

