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
    
    @State private var offset: CGFloat = 0
    @State private var index = 0
    
    let spacing: CGFloat = 8
    
    var today: String {
        let date = Date()
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date)
    }
    
    var weeks: [[Date]] {
        let ds = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekOfMonth, for: Date())!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        let ds1 = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekOfMonth, for: Date())!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        
        let ds2 = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekOfMonth, for: Date())!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        
        return [ds, ds1, ds2]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: self.spacing) {
                        ForEach(weeks, id: \.self) { week in
                            
                            ForEach(week, id: \.self) { date in
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
                                    }
                                    .padding(.trailing, 7)
                                    .frame(width: geometry.size.width / 8)
                                }
                            }
                        }
                    }
                }
                .content.offset(x: self.offset)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.weeks.count - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                            withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                        })
                )
                Divider()
            }
            
            
        }.frame(height: 50)
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
