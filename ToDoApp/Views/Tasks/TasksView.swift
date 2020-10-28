//
//  TasksView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI
import PartialSheet

struct TasksView: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    @Environment(\.calendar) var calendar
    
    @State var selectedDate = Date()
    
    var today: String {
        let date = Date()
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date)
    }
   
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Your tasks")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                    }
                    .padding(.bottom, 40)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(today)
                                .font(.caption)
                            
                            Text("Today")
                                .bold()
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        Button {
                            sheetManager.showPartialSheet(content: {
                                AddTaskView()
                            })
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                
                                Text("Add task")
                                    .bold()
                                    
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(10)
                                
                                
                        }
                    }
                    CalendarLineView(selectedDate: $selectedDate)
                    
                    TasksListView(selectedDate: $selectedDate)
                            

                }.padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
