//
//  Task.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import RealmSwift

class Task: Object, Identifiable {
    @objc dynamic var id = UUID()
    @objc dynamic var title: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var createdOn = Date()
    @objc dynamic var isDone: Bool = false
    
    override static func ignoredProperties() -> [String] {
        return ["id"]
    }
}
