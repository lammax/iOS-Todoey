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
    
    let dbManager: DBManager = DBManager.sharedInstance
    let alertManager: AlertManager = AlertManager.sharedInstance
    
    var itemArray: [CellItem] = [CellItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var categoryPredicate: NSPredicate?
    
    var selectedCategory: ItemCategory? {
        didSet {
            if let name = selectedCategory?.categoryName  {
                categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", name)
                self.loadItems()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems(with: CellItem.fetchRequest())
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
        
        self.dbManager.delete(currentItem)
        self.itemArray.remove(at: indexPath.row)

    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = self.alertManager.askAlert(for: "Item") { (title) in
            let newItem = self.dbManager.createCellItem(title: title, category: self.selectedCategory)
            self.itemArray.append(newItem)
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    func loadItems(with request: NSFetchRequest<NSFetchRequestResult> = CellItem.fetchRequest(), predicate: NSPredicate? = nil) {
        let compaundPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, self.categoryPredicate].reduce(into: [], { (acc, mbPredicate) in
            if let prdc = mbPredicate { acc.append(prdc) }
        }))
        request.predicate = compaundPredicate
        dbManager.loadItems(with: request) { (maybeItems) in
            if let items = maybeItems {
                self.itemArray = items as! [CellItem]
            }
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //https://academy.realm.io/posts/nspredicate-cheatsheet/
        let request: NSFetchRequest<NSFetchRequestResult> = CellItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request: NSFetchRequest<NSFetchRequestResult> = CellItem.fetchRequest()
            let containsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.loadItems(with: request, predicate: containsPredicate)
        }
    }
    
}
