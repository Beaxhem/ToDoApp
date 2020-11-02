//
//  TaskView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var db: DatabaseManager

    var task: Task

    @State var isPresented = false
    
    var body: some View {
        if !task.isInvalidated {
            VStack(alignment: .leading, spacing: 0) {
                Text("Urgent")
                    .autocapitalization(.allCharacters)
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(0)
                Divider()
                    .padding(.top, 7)
                    .padding(.bottom, 10)
                
                HStack {
                    Rectangle()
                        .fill(Color(hex: task.category?.color ?? "#000000"))
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .frame(width: 3)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.title2)
                            .bold()
                        
                        Text(task.details)
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("10-11 am")
                    }
                    .font(.subheadline)
                    
                    Spacer()
                    
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
                }.padding(.top, 20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 7)
            .onTapGesture {
                self.isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                TaskDetailsView(task: task)
            }
        }
    }

    private func deleteTask() {
       db.delete(object: task)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task())
    }
}
