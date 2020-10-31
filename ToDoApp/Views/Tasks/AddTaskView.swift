//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI
import PartialSheet

struct AddTaskView: View {
    @State var taskTitle = ""
    @State var details = ""
    @State var date = Date()
    
    @ObservedObject var db = DatabaseManager.shared
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        ScrollView {
            VStack {
                Text("New task")
                TextField("", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Details")
                TextEditor(text: $details)
                    .border(Color.gray, width: 2)
                Button(action: { addTask() }) {
                    Text("Create task")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)

                }
                
                DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                    Text("Select a date")
                }
            }.padding()
        }
        
    }
    
    func addTask() {
        let task = Task()
        
        task.title = taskTitle
        task.details = details
        task.isDone = false
        
        do {
            try db.saveToDatabase(object: task)
            sheetManager.closePartialSheet()
        } catch DatabaseError.writeError {
            print("Some trouble with writing to db.")
        } catch let error {
            print("Unknown error: ", error)
        }
        
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
