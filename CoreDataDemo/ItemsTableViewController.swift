//
//  ItemsTableViewController.swift
//  CoreDataDemo
//
//  Created by Rahul Kumar Singh on 10/05/21.
//  Copyright © 2021 Ajeet N. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var parentCategory: CategoryList? {
        didSet {
            loadItem()
        }
    }
    private var itemsArray = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var searchBarObj: UISearchBar!{
        didSet{
            self.searchBarObj.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightButtonAction))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func rightButtonAction() {
        showAlertWithTextField(itm: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.itemsArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction.init(style: .normal, title: "Edit") { (action, indexPath) in
            self.showAlertWithTextField(itm: self.itemsArray[indexPath.row])
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete") { (action, indexPath) in
            self.deleteItem(item: self.itemsArray[indexPath.row])
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction,editAction]
    }
}

extension ItemsTableViewController {
    func saveItem() {
        do {
            try context.save()
            loadItem()
        } catch {
            print("Error while saving :\(error.localizedDescription)")
        }
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        do {
            let itemPredicate = NSPredicate(format: "parent.title MATCHES %@", self.parentCategory!.title!)
            if let predicate = predicate {
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, itemPredicate])
                request.predicate = compoundPredicate
            } else {
                request.predicate = itemPredicate
            }
            itemsArray = try context.fetch(request)
        } catch {
            print("Error while retriving items :\(error)")
        }
    }
    
    func deleteItem(item: Item) {
        context.delete(item)
        saveItem()
    }
}

extension ItemsTableViewController {
    func showAlertWithTextField(itm: Item?) {
        var field = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Category Name"
            textField.text = itm?.name
            field = textField
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            if let ittm = itm {
                ittm.name = field.text
                self.saveItem()
            } else {
                let item = Item(context: self.context)
                item.name = field.text
                item.parent = self.parentCategory
                self.saveItem()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ItemsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescripter]
        loadItem(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("UISearchBar.text cleared!")
            loadItem()
        }
    }
}
