//
//  Item.swift
//  Todoit
//
//  Created by Luke on 8/15/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var color: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
