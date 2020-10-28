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
    
    var today: String {
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        
        return formatter1.string(from: date)
    }
    
    var dates: [Date] {
        let ds = calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: Date())!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
        return ds
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        Text("Your tasks")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                    }
                    
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
                            Text("Add new task")
                                .bold()
                                .padding(10)
                                .background(Color.red)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            LazyHStack {
                                ForEach(dates, id: \.self) { date in
                                    VStack {
                                        if let components = date.get(.day, .weekday), let day = components.date, let weekday = components.weekday {
                                            Text("\(weekday)")
                                                .font(.callout)
                                            
                                            Text("\(day)")
                                                .font(.title2)
                                            Text("Hello")
                                        } 
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    
                    TasksListView()
                            

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
