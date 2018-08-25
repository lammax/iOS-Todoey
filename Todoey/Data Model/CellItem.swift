//
//  CellItem.swift
//  Todoey
//
//  Created by Mac on 22.08.2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

class CellItem {
    var title : String = ""
    var done : Bool = false
    
    init() {}
    
    init(title : String, done : Bool) {
        self.title = title
        self.done = done
    }
    
    init(title : String) {
        self.title = title
    }
    
    func setState(done : Bool) {
        self.done = done
    }
}
