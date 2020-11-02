//
//  CalendarCellView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 30.10.2020.
//

import SwiftUI

struct CalendarCell: View {
    let date: Date
    
    @ObservedObject var db = DatabaseManager.shared
    
    var body: some View {
        Group {
            if let day = date.get(.day) {
//                if day == 1 {
//                    Text(date.monthAsString())
//                        .bold()
//                        .foregroundColor(.purple)
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                }
                VStack(spacing: 0) {
                    let weekday = date.get(.weekday)
                    
                    if isToday(date: date) {
                        Text("\(getWeekday(weekday))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(day)")
                            .font(.title2)
                            .foregroundColor(.red)
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 2)
                            .zIndex(1)
                    } else {
                        Text("\(getWeekday(weekday))")
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                        Text("\(day)")
                            .font(.title2)
                    }
                }
                .padding(.trailing, 7)
                
            }
        }
        
    }
    
    private func isToday(date: Date) -> Bool {
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date) == formatter.string(from: db.selectedDate)
    }
    
    private func getWeekday(_ day: Int) -> String {
        switch day - 1 {
        case 1:
            return "Mon"
        case 2:
            return "Tue"
        case 3:
            return "Wed"
        case 4:
            return "Thu"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        case 0:
            return "Sun"
        default:
            return "Unknown weekday"
        }
    }
    
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(date: Date())
    }
}
