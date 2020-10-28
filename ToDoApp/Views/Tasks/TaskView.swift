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
                    Text(task.summary)
                        .font(.title2)
                        .bold()
                    
                    Text(task.summary)
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
            }.padding(.top, 20)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .contextMenu {
            Button(action: {
                
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task())
    }
}