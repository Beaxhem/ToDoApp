//
//  CalendarLineView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 28.10.2020.
//

import SwiftUI

struct CalendarLineView: View {
    @Environment(\.calendar) var calendar
    
    @Binding var selectedDate: Date
    
    var today: String {
        let date = Date()
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date)
    }
    
    var dates: [Date] {
        let todayy = Date()
        
        let twoWeeksAgo = todayy.addingTimeInterval(-1200000)
        let ds = calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: twoWeeksAgo)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        return ds
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                HStack {
                    ForEach(dates, id: \.self) { date in
                        if let day = date.get(.day), let weekday = date.get(.weekday), let month = date.get(.month), let year = date.get(.year) {
                            if day == 1 {
                                Text("Oct")
                                    .bold()
                                    .foregroundColor(.purple)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            VStack(spacing: 0) {
                                if let d = Date(), d.get(.day) == day, d.get(.month) == month, d.get(.year) == year {
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
                            }.padding(.horizontal, 7)
                        }
                    }
                }
                Divider()
            }
        }
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

struct CalendarLineView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarLineView(selectedDate: .constant(Date()))
    }
}
