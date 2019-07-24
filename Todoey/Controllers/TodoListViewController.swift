//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 18.08.2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    //let dbManager: DBManager = DBManager.sharedInstance
    let realmManager: RealmManager = RealmManager.sharedInstance
    let alertManager: AlertManager = AlertManager.sharedInstance
    
    /*var itemArray: [CellItem] = [CellItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }*/
    var itemArray: Results<Item>? {
        didSet {
            self.tableView.reloadData()
        }
    }

    /*var selectedCategory: ItemCategory? {
        didSet {
            if let name = selectedCategory?.categoryName  {
                categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", name)
                self.loadItems()
            }
        }
    }*/
    var selectedCategory: Category? {
        didSet {
            if let name = selectedCategory?.name  {
                self.navigationBar.title = "Items of \(name)"
                self.loadItems()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        self.setupObservers()
    }
    
    private func setupObservers() {
        self.realmManager.addObserver(for: itemArray) { [weak self] in
            self?.tableView.reloadData()
        }
    }

    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        let item = itemArray?[indexPath.row]

        cell.textLabel?.text = item?.title ?? "No Items Added"
        cell.accessoryType = (item?.done ?? false) ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentItem = self.itemArray?[indexPath.row] {
            self.realmManager.update {
                currentItem.done = !(currentItem.done)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = (currentItem.done) ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = self.alertManager.askAlert(for: "Item") { (title) in
            self.realmManager.createItem(title: title, maybeCategory: self.selectedCategory)
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    func loadItems() {
        self.itemArray = self.selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        /*let compaundPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, self.categoryPredicate].reduce(into: [], { (acc, mbPredicate) in
            if let prdc = mbPredicate { acc.append(prdc) }
        }))
        request.predicate = compaundPredicate
        dbManager.loadItems(with: request) { (maybeItems) in
            if let items = maybeItems {
                self.itemArray = items as! [CellItem]
            }
        }*/
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //https://academy.realm.io/posts/nspredicate-cheatsheet/
        /*let request: NSFetchRequest<NSFetchRequestResult> = CellItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]*/
        //self.loadItems { $0.title.contains(searchBar.text ?? "")}
        self.itemArray = self.selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text ?? "").sorted(byKeyPath: "dateCreated", ascending: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            /*let request: NSFetchRequest<NSFetchRequestResult> = CellItem.fetchRequest()
            let containsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.loadItems(with: request, predicate: containsPredicate)*/
            self.itemArray = self.selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text ?? "").sorted(byKeyPath: "dateCreated", ascending: true)
        }
    }
    
}
