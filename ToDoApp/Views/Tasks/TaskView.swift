//
//  TaskView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    
    var body: some View {

        VStack(alignment: .leading) {
            Text(task.summary)
                .font(.headline)
            
            Text(task.summary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        
            
        
        
        
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task())
    }
}
