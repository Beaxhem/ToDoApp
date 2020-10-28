//
//  TasksListView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI

struct TasksListView: View {
    
    @EnvironmentObject var db: DatabaseManager
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(alignment: .leading) {
                ForEach(db.tasks) { task in
                    TaskView(task: task)
                }
            }
            .frame(width: geometry.size.width)
            .onAppear {
                db.getTasks()
            }
        }
    }

}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView()
    }
}
