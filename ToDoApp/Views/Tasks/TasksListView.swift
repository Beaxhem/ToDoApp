//
//  TasksListView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI

struct TasksListView: View {
    @EnvironmentObject var db: DatabaseManager
    
    @Binding var selectedDate: Date
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 15) {
            ForEach(db.tasks) { task in
                TaskView(task: task)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .onAppear {
            db.getTasks()
        }
        
    }

}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(selectedDate: .constant(Date()))
    }
}
