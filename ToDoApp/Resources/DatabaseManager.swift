//
//  DatabaseManager.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import RealmSwift
import SwiftUI

enum DatabaseError: Error {
    case writeError
}

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    @Published var tasks = [Task]()
    
    func saveToDatabase(object: Object) throws {
        do {
            try realm.write {
                realm.add(object)
                print("Successfully added a task to a db")
                getTasks()
            }
        } catch let error {
            throw error
        }
    }
    
    func getTasks() {
        withAnimation {
            let t = Array(realm.objects(Task.self).sorted(byKeyPath: "date", ascending: false))
            self.tasks = t
        }
    }
    
    func delete(object: Object) {
        if !object.isInvalidated {
            let wg = DispatchGroup()
            wg.enter()
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                do {
                    try strongSelf.realm.write {
                        strongSelf.realm.delete(object)
                    }
                    print("Successfully deleted the task")
                    
                } catch let error {
                    print(error)
                    return
                }
                
                wg.leave()
            }
            
            wg.notify(queue: .main) {
                if object.isInvalidated {
                    self.getTasks()
                }
            }
        }
    }
    
    func completeTask(task: Task) throws {
        try realm.write {
            task.isDone.toggle()
            
            getTasks()
        }
    }
}

