//
//  Item+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Rahul Kumar Singh on 10/05/21.
//  Copyright © 2021 Ajeet N. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var parent: CategoryList?

}

extension Item : Identifiable {

}
