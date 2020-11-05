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
    @State var details = "Enter details..."
    @State var startDate = Date()
    @State var category: Category? = nil
    
    @ObservedObject var db = DatabaseManager.shared
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("New task")
                    .font(.headline)
                
                TextField("", text: $taskTitle)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                
                DatePicker(selection: $startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                    Text("Start")
                }.datePickerStyle(DefaultDatePickerStyle())
                
                OptionsView(options: db.categories, selectedOption: $category)
                
                Text("Details")
                    .font(.headline)
                
                TextEditor(text: $details)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    
                
                Button(action: { addTask() }) {
                    Text("Create task")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        

                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top)
                
                
            }.padding()
            .onAppear {
                getCategories()
            }
        }
        
    }
    
    func getCategories() {
        do {
            try db.getCategories()
        } catch let error {
            print(error)
        }
    }
    
    func addTask() {
        let task = Task()
        
        task.title = taskTitle
        task.details = details
        task.isDone = false
        task.startDate = startDate
        task.category = category!
        
        do {
            try db.saveToDatabase(object: task)
            sheetManager.closePartialSheet()
        } catch DatabaseError.writeError {
            print("Some trouble with writing to db.")
        } catch let error {
            print("Unknown error: ", error)
        }
        
        NotificationCenter.shared.scheduleTaskReminderNotification(task: task)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
