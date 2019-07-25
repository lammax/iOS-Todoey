//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 23.07.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    //let dbManager: DBManager = DBManager.sharedInstance
    let realmManager: RealmManager = RealmManager.sharedInstance
    let alertManager: AlertManager = AlertManager.sharedInstance
    
    /*var categoryArray: [ItemCategory] = [ItemCategory]() {
        didSet {
            self.tableView.reloadData()
        }
    }*/
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
        self.setupObservers()
        self.setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    private func setupObservers() {
        self.realmManager.addObserver(for: categoryArray) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        super.deleteAction = { index in
            self.realmManager.delete(object: self.categoryArray?[index])
        }
    }
    
    override func deleteObject(at indexPath: IndexPath) {
        self.realmManager.delete(object: self.categoryArray?[indexPath.row])
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = self.alertManager.askAlert(for: "Category") { (title) in
            self.realmManager.createCategory(title: title)
        }
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK - TableView Datasource Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = categoryArray?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No Categories Added"

        return cell
    }
}

//MARK: - TableView Delegate
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
}

//MARK - Model Manipulation Methods
extension CategoryViewController {
    func loadItems() {
        realmManager.loadItems(with: Category.self) { (maybeCategories) in
            if let categories = maybeCategories {
                self.categoryArray = categories
            }
        }
    }
}
