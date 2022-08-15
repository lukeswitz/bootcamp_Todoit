//
//  Category.swift
//  Todoit
//
//  Created by Luke on 8/15/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
