//
//  ItemsTableView.swift
//  CoreDataDemo
//
//  Created by Ajeet N on 23/08/20.
//  Copyright © 2020 Ajeet N. All rights reserved.
//

import UIKit

protocol TableViewCellTapDelegate:class {
    func didTap(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?,_ item:CategoryList?)
    func didEdit(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?,_ item:CategoryList?)
    func didDelete(_ cell: ItemsTableViewCell?, _ atIndexPath: IndexPath?,_ item:CategoryList?)
}

class ItemsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var items = [CategoryList]() {
        didSet{
            self.reloadData()
        }
    }
    
    var headerTitles = [String]() {
        didSet {
            self.reloadSections(IndexSet.init(arrayLiteral: 0), with: .automatic)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
    weak var relatedItemsDelegate: TableViewCellTapDelegate?

    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(){
        self.delegate = self
        self.dataSource = self
        self.register(UINib.init(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemsTableViewCell")
        self.backgroundColor = .clear
        self.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsTableViewCell", for: indexPath) as! ItemsTableViewCell
        let item = items[indexPath.row]
        cell.nameObj.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        relatedItemsDelegate?.didTap(nil, indexPath, nil)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction.init(style: .normal, title: "Edit") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! ItemsTableViewCell
            self.relatedItemsDelegate?.didEdit(cell, indexPath, self.items[indexPath.row])
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! ItemsTableViewCell
            self.relatedItemsDelegate?.didDelete(cell, indexPath, self.items[indexPath.row])
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction,editAction]
    }
}
