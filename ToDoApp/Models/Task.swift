//
//  Task.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import RealmSwift
import SwiftUI

class Category: Object, Optionable {
    var id = UUID()
    
    @objc dynamic var name = "Test"
    @objc dynamic var color = ""
    
    func asOption() -> Option {
        let option = Option()
        
        option.title = self.name
        
        return option
    }
    
    override static func ignoredProperties() -> [String] {
        return ["id"]
    }
}

class Task: Object, Identifiable {
    @objc dynamic var id = UUID()
    @objc dynamic var title: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var isDone: Bool = false
    @objc dynamic var category: Category? = Category()
    
    override static func ignoredProperties() -> [String] {
        return ["id"]
    }
}
