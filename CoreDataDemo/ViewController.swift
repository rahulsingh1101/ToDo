//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Ajeet N on 23/08/20.
//  Copyright © 2020 Ajeet N. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var itemsArray = [CategoryList](){
        didSet{
            relatedItems.items = itemsArray
        }
    }
    
    private let relatedItems = ItemsTableView()
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        
        relatedItems.relatedItemsDelegate = self
        relatedItems.headerTitles = ["Related Items"]
        relatedItems.items = itemsArray
        
        searchBar.delegate = self
        
        view.addAutolayoutSubview(relatedItems)
        view.addAutolayoutSubview(searchBar)
        
        navigationItem.title = "Category"
        
        NSLayoutConstraint.activate([
            relatedItems.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            relatedItems.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            relatedItems.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            relatedItems.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        showAlertWithTextField(itm: nil)
    }
}

extension ViewController {
    func saveItem() {
        do {
            try context.save()
            loadItem()
        } catch {
            print("Error while saving :\(error.localizedDescription)")
        }
    }
    
    func loadItem(with request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()) {
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error while retriving items :\(error)")
        }
    }
    
    func deleteItem(item: CategoryList) {
        context.delete(item)
        saveItem()
    }
}

extension ViewController {
    func showAlertWithTextField(itm: CategoryList?) {
        var field = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Category Name"
            textField.text = itm?.title
            field = textField
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            if let ittm = itm{
                ittm.title = field.text
                self.saveItem()
            } else {
                let item = CategoryList(context: self.context)
                item.title = field.text
                self.saveItem()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescripter]
        loadItem(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("UISearchBar.text cleared!")
            loadItem()
        }
    }
}

extension ViewController: TableViewCellTapDelegate {
    func didTap(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?, _ item: CategoryList?) {
        guard let indexPath = atIndexPath else { return }
        let viewController = self.storyboard?.instantiateViewController(identifier: "ItemsTableViewController") as! ItemsTableViewController
        viewController.parentCategory = self.itemsArray[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didEdit(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?, _ item: CategoryList?) {
        showAlertWithTextField(itm: item)
    }
    
    func didDelete(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?, _ item: CategoryList?) {
        deleteItem(item: item!)
    }
}

extension UIView {
    func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    func apply<T:UIView>(_ view: T, completion:((T))->Void) {
        completion(view)
    }
}
