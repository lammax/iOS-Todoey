//
//  Category.swift
//  Todoey
//
//  Created by Mac on 23.07.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Category: Object {
    @objc dynamic var name: String = ""
    let items: List<Item> = List<Item>()
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    required init() {
        super.init()
        //fatalError("init() has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
        //fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        //fatalError("init(value:schema:) has not been implemented")
    }
}
