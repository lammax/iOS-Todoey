//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mac on 25.07.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {
    
    //first variant of deletion
    var deleteAction: (Int) -> Void = {_ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.tableView.rowHeight = 80.0
    }
    
    //second variant of deletion
    func deleteObject(at indexPath: IndexPath) {
        //so code for deletion
    }

}

extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //self.deleteAction(indexPath.row)
            self.deleteObject(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}

//MARK - TableView Datasource Methods
extension SwipeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self

        return cell
    }
}
