//
//  Data.swift
//  Todoey
//
//  Created by Mac on 23.07.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Item: Object {
    @objc dynamic var title:        String = ""
    @objc dynamic var done:         Bool   = false
    @objc dynamic var dateCreated:  Date?
    var parentCategory: LinkingObjects = LinkingObjects(fromType: Category.self, property: "items")
    
    init(title: String, done: Bool = false) {
        super.init()
        self.title = title
        self.done = done
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
