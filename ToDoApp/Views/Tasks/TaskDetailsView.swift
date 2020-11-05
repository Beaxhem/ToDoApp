//
//  TaskDetailsView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 31.10.2020.
//

import SwiftUI

struct TaskDetailsView: View {
    var task: Task
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    close()
                } label: {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                }
                    
                Spacer()
                
                Button {
    
                } label: {
                    Image(systemName: "pencil.circle")
                        .font(.title2)
                }
                
                Button {
                    close()
                    withAnimation {
                        DatabaseManager.shared.delete(object: task)
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .padding(.horizontal)
                }
                
            
                Button {
                    do {
                        try DatabaseManager.shared.completeTask(task: task)
                    } catch let error {
                        print(error)
                    }
                } label: {
                    Text(task.isDone ? "Completed ✅": "Complete")
                        .foregroundColor(task.isDone ? Color.black.opacity(0.3) : .black)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        
                }
                    
                
            }.padding(.bottom)
            
            Text(task.title)
                .font(.largeTitle)
                .bold()
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(getFormatter(style: .full).string(from: task.startDate))
                    .font(.subheadline)
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Details")
                    .font(.headline)
                    .foregroundColor(.gray)
                Divider()
            }
            
            Text(task.details)
            
            Spacer()
        }
        .padding()
       
    }
    
    private func close() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(task: Task())
    }
}
