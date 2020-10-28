//
//  DatabaseManager.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import RealmSwift

enum DatabaseError: Error {
    case writeError
}

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    @Published var tasks = [Task]()
    
    func saveToDatabase(obj: Object) throws {
        do {
            try realm.write {
                realm.add(obj)
                print("Successfully added a task to a db")
                getTasks()
            }
        } catch let error {
            throw error
        }
    }
    
    func getTasks() {
        let t = Array(realm.objects(Task.self).sorted(byKeyPath: "createdOn", ascending: false))
        self.tasks = t
    }
}

