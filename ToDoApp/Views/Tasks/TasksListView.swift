//
//  TasksListView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI

struct TasksListView: View {
    @ObservedObject var db = DatabaseManager.shared
    
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            if !db.tasks.isEmpty {
                LazyVStack(alignment: .leading, spacing: 15) {
                    let uncompletedTasks = getUncompletedTasks(db.tasks)
                    
                    Text("Uncompleted tasks (\(uncompletedTasks.count))")
                        .font(.headline)
                    
                    if !uncompletedTasks.isEmpty {
                        ForEach(uncompletedTasks) { task in
                            TaskView(task: task)
                        }
                    }
                }
                
                Divider()
                
                LazyVStack(alignment: .leading, spacing: 15) {
                    let completedTasks = getCompletedTasks(db.tasks)
                    
                    Text("Completed tasks (\(completedTasks.count))")
                        .font(.headline)
                    
                    if !completedTasks.isEmpty {
                        ForEach(completedTasks) { task in
                            TaskView(task: task)
                        }
                    }
                }
            } else {
                Text("No tasks yet :(")
                    .padding()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .onAppear {
            getTasks()
        }
    }
    
    private func getTasks() {
        db.getTasks(of: selectedDate)
    }
    
    private func getCompletedTasks(_ tasks: [Task]) -> [Task] {
        var completedTasks = [Task]()
        
        for task in db.tasks {
            if task.isDone {
                completedTasks.append(task)
            }
        }
        
        return completedTasks
    }
    
    private func getUncompletedTasks(_ tasks: [Task]) -> [Task] {
        var uncompletedTasks = [Task]()
        
        for task in db.tasks {
            if !task.isDone {
                uncompletedTasks.append(task)
            }
        }
        
        return uncompletedTasks
    }
}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(selectedDate: .constant(Date()))
    }
}
