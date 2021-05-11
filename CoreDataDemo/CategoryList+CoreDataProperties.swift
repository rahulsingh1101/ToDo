//
//  CategoryList+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Rahul Kumar Singh on 10/05/21.
//  Copyright © 2021 Ajeet N. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryList> {
        return NSFetchRequest<CategoryList>(entityName: "CategoryList")
    }

    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension CategoryList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension CategoryList : Identifiable {

}
