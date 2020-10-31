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
                        .fill(Color.red)
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
                    
                    if task.isDone {
                        Text("Completed ✅")
                            .foregroundColor(Color.black.opacity(0.3))
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    } else {
                        Button {
                            do {
                                try DatabaseManager.shared.completeTask(task: task)
                            } catch let error {
                                print(error)
                            }
                        } label: {
                            Text("Complete")
                                .foregroundColor(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    

                }.padding(.top, 20)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
//            .contextMenu {
//                Button(action: {
//                    withAnimation {
//                        deleteTask()
//                    }
//                    
//                }) {
//                    Text("Delete")
//                    Image(systemName: "trash")
//                }
//            }
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
