//
//  Item.swift
//  Todoey
//
//  Created by Reimo on 2/9/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import Foundation
import RealmSwift



class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done :Bool = false 
    @objc dynamic var dateCreated : Date?
    // Creating Inverse Relationship by realm.
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // each item has aparent category with data type Category.
}
