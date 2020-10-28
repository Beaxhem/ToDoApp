//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI
import PartialSheet

struct AddTaskView: View {
    @State var summary = ""
    @State var details = ""
    
    @EnvironmentObject var db: DatabaseManager
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        VStack {
            Text("Summary")
            TextField("", text: $summary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Details")
            TextField("", text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: { addTask() }) {
                Text("Create task")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)

            }
        }.padding()
    }
    
    func addTask() {
        let task = Task()
        
        task.summary = summary
        task.details = details
        
        do {
            try db.saveToDatabase(obj: task)
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
