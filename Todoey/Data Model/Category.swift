//
//  Category.swift
//  Todoey
//
//  Created by Reimo on 2/9/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    // Creating Forward Relationship by realm.
    
    let items = List<Item>()
    //each category has a list of items with data type <Item>.
}
