//
//  CalendarLineView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 28.10.2020.
//

import SwiftUI

struct CalendarLineView: View {
    @Environment(\.calendar) var calendar
    
    @ObservedObject var db = DatabaseManager.shared
    
    @Binding var selectedDate: Date
    
    @State private var offset: CGFloat = 0
    @State private var index = 0
    @State private var currentOffset: CGFloat = 0
    @State private var currentMonthAndYear = ""
    
    let spacing: CGFloat = 8
    
    @State var dates: [Date]  = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // Display current month and year
                Text(currentMonthAndYear)
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.bottom, 10)
                
                GeometryReader { outsideProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        // ZStack to hide Color.clear
                        ZStack {
                            // Calculate inner offset
                            GeometryReader { insideProxy in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                            }
                            
                            HStack(spacing: self.spacing) {
                                ForEach(dates, id: \.self) { date in
                                    CalendarCell(date: date)
                                        .frame(width: geometry.size.width / 8)
                                        .onTapGesture {
                                            db.selectedDate = date
                                            db.getTasks()
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
                                // Check if offset is enough to scroll
                                // Forward
                                if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.dates.count - 1 {
                                    self.index += 1
                                }
                                // Back
                                if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                    self.index -= 1
                                }
                                
                                var d = self.dates
                                
                                // The conditions for loading new and removing extra dates
                                if self.index == 0 {
                                    d = leadingLimitReached()
                                } else if self.index > 4 {
                                    d = trailingLimitReached()
                                }
                                
                                self.dates = d
                                
                                withAnimation { self.offset = -(geometry.size.width + 2*self.spacing) * CGFloat(self.index) }
                                
                                // Update current date
                                getMonthByIndex()
                            })
                    )
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.currentOffset = value[0]
                    }
                }
                Divider()
            }
        }
        .frame(height: 90)
        .onAppear {
            // Load data on appear
            loadDates()
            getMonthByIndex()
            
        }
    }
    
    // Get current month on appear
    func loadDates(){
        let current = generateDays(for: Date())

        self.dates = current
        
        db.getAllTasks()
    }
    
    // Executed on reaching the first loaded element
    func leadingLimitReached() -> [Date] {
        var d = self.dates
        d = removeFuture(dates: d)
        
        let past = loadPast(dates: d)
        d.insert(contentsOf: past, at: 0)
        
        self.index += past.count / 7
        
        return d
    }
    
    // Executed on reaching the last loaded element
    func trailingLimitReached() -> [Date] {
        var d = self.dates
        
        d = removePast(dates: d)
        
        let future = loadFuture(dates: d)
        d.append(contentsOf: future)
        
        self.index -= 4
        
        return d
    }
    
    // Load dates on reaching leading limit
    func loadPast(dates: [Date]) -> [Date] {
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: dates.first!)
        
        let past = generateDays(for: monthAgo!)
    
        return past
    }
    
    // Load dates on reaching trailing limit
    func loadFuture(dates: [Date]) -> [Date] {
        let monthLater = calendar.date(byAdding: .month, value: 1, to: dates.last!)
        
        let future = generateDays(for: monthLater!)
        
        return future
    }

    // Remove dates on reaching the first loaded element
    private func removeFuture(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let futureNumber = generateDays(for: dates.last!).count
            
            return Array(dates[..<(dates.count - futureNumber)])
        }
        
        return dates
        
    }
    
    // Remove dates on reaching the last loaded element
    private func removePast(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let pastNumber = generateDays(for: dates.first!).count
            
            return Array(dates[(pastNumber)...])
        }
        
        return dates
    }
    
    // Update info about current month and year
    private func getMonthByIndex() {
        var monthCounter: [Int: Int] = [:]
        
        for date in self.getVisibleDates() {
            monthCounter[date.get(.month), default: 0] += 1
        }
        
        var dateComponents: DateComponents? = calendar.dateComponents([.month, .year], from: Date())
        dateComponents?.month = monthCounter.max { a, b in a.value < b.value}?.key

        let date: Date? = calendar.date(from: dateComponents!)
        
        self.currentMonthAndYear = date!.monthAsString()
    }
    
    // Get dates which are visible at the moment
    private func getVisibleDates() -> [Date] {
        var monthNum = self.index * 7
        
        if dates[monthNum...].count < 6 {
            self.dates = loadFuture(dates: dates)
            monthNum -= 4
            self.index -= 4
        }
        
        let endLimit = monthNum + 6
        
        return Array(self.dates[monthNum..<endLimit])
    }
    
    // Generate days of the same month as given
    private func generateDays(for date: Date) -> [Date] {
        return calendar.generateDates(
            inside: calendar.dateInterval(of: .month, for: date)!,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
    }
}

// Used to update current offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
