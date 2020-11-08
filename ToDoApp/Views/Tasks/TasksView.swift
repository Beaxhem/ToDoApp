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
            AddTaskButtonView {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
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
                        
                    
                        DateIndicator(date: $selectedDate)
                            
                        CalendarLineView(selectedDate: $selectedDate)
                        
                        TasksListView(selectedDate: $selectedDate)
                            .padding(.top)

                    }.padding()
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .onAppear {
                    NotificationCenter.shared.scheduleTaskReminderNotification(task: Task())
                }
            }
            
        }

    }
    
    
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
