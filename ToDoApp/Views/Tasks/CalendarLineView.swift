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
    @State private var currentOffset: CGFloat = 0
    
    let spacing: CGFloat = 8
    
    var today: String {
        let date = Date()
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date)
    }
    
    @State var dates: [Date]  = []
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { outsideProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            GeometryReader { insideProxy in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                                    
                            }
                            HStack(spacing: self.spacing) {
                                ForEach(dates, id: \.self) { date in
                                    CalendarCell(date: date)
                                        .frame(width: geometry.size.width / 8)
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
                                if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.dates.count - 1 {
                                    self.index += 1
                                }
                                if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                    self.index -= 1
                                }
                                
                                let scrollWidth = CGFloat(dates.count) * (geometry.size.width / 8) + CGFloat(dates.count - 1) * self.spacing
                                var d = self.dates
                                
                                if currentOffset <= 0 {
                                    
                                    
                                    d = removeFuture(dates: d)
                                    print("remove future", d.count)
                                    
                                    let past = loadPast(dates: d)
                                    print("load past", d.count)
                                    d.insert(contentsOf: past, at: 0)
                                    
                                    self.index += past.count / 7
                                    
                                } else if currentOffset >= scrollWidth - 250 {
                                    d = removePast(dates: d)
                                    
                                    let future = loadFuture(dates: d)
                                    d.append(contentsOf: future)
                                    
                                    self.index -= 3
                                }
                                
                                self.dates = d
                                withAnimation { self.offset = -(geometry.size.width + 2*self.spacing) * CGFloat(self.index) }
                            })
                    )
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.currentOffset = value[0]
                    }
                }
                Divider()
            }
        }
        .frame(height: 50)
        .onAppear(perform: loadDates)
    }
    
    func loadDates(){
        let current = calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: Date())!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )

        self.dates = current
    }
    
    func loadPast(dates: [Date]) -> [Date] {
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: dates.first!)
        
        let past = calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: monthAgo!)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    
        return past
    }
    
    func loadFuture(dates: [Date]) -> [Date] {
        let monthLater = Calendar.current.date(byAdding: .month, value: 1, to: dates.last!)
        
        let future = calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: monthLater!)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        
        return future
    }

    private func removeFuture(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let futureNumber = calendar.generateDates(
                inside: calendar.dateInterval(of: .month, for: dates.last!)!,
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            ).count
            
            return Array(dates[..<(dates.count - futureNumber)])
        }
        
        return dates
        
    }
    
    private func removePast(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let pastNumber = calendar.generateDates(
                inside: calendar.dateInterval(of: .month, for: dates.first!)!,
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            ).count
            
            return Array(dates[(pastNumber)...])
        }
        
        return dates
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
    }
}

struct CalendarCell: View {
    let date: Date
    
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
        let today = Date()
        
        if today.get(.day) == date.get(.day), today.get(.month) == date.get(.month), today.get(.year) == date.get(.year) {
            return true
        }
        
        return false
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

struct CalendarLineView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarLineView(selectedDate: .constant(Date()))
    }
}
