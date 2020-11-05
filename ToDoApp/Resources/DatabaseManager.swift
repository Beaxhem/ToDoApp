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
    
    @Published var allTasks = [Task]()
    @Published var tasks = [Task]()
    @Published var categories = [Category]()
    @Published var selectedDate = Date()
    
    func saveToDatabase(object: Object) throws {
        do {
            try realm.write {
                realm.add(object)
                print("Successfully added a task to a db")
                getAllTasks()
            }
        } catch let error {
            throw error
        }
    }
    
    func getTasks() {
        withAnimation {
            let t = Array(realm.objects(Task.self).filter("startDate BETWEEN %@", getStartAndEndOfDate(selectedDate)).sorted(byKeyPath: "startDate", ascending: false))
            self.tasks = t
        }
    }
    
    func _getTasks() -> [Task] {
        let t = Array(realm.objects(Task.self).filter("startDate BETWEEN %@", getStartAndEndOfDate(selectedDate)).sorted(byKeyPath: "startDate", ascending: false))
        
        return t
    }
    
    func getAllTasks() {
        getTasks()
        
        let t = Array(realm.objects(Task.self).sorted(byKeyPath: "startDate", ascending: false))
        
        self.allTasks = t
    }
    
    func getStartAndEndOfDate(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        let start = calendar.generateDates(
            inside: calendar.dateInterval(of: .day, for: date)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )[0]
        
        let endDate = calendar.date(byAdding: .day, value: 1, to: start)!
        
        let end = calendar.generateDates(
            inside: calendar.dateInterval(of: .day, for: endDate)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )[0]
        
        return [start, end]
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
    
    func getCategories() throws {
        let c = realm.objects(Category.self)
        
        self.categories = Array(c)
    }
}

