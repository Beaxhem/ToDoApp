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
    @State private var currentMonth = ""
    
    let spacing: CGFloat = 8
    
    @State var dates: [Date]  = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Text(currentMonth)
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.bottom, 10)
                
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
                                
                                var d = self.dates
                                
                                if self.index == 0 {
                                    d = leadingLimitReached()
                                } else if self.index > 4 {
                                    d = trailingLimitReached()
                                }
                                
                                self.dates = d
                                
                                withAnimation { self.offset = -(geometry.size.width + 2*self.spacing) * CGFloat(self.index) }
                                
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
            loadDates()
            getMonthByIndex()
            
        }
    }
    
    func loadDates(){
        let current = generateDays(for: Date())

        self.dates = current
    }
    
    func leadingLimitReached() -> [Date] {
        var d = self.dates
        d = removeFuture(dates: d)
        
        let past = loadPast(dates: d)
        d.insert(contentsOf: past, at: 0)
        
        self.index += past.count / 7
        
        return d
    }
    
    func trailingLimitReached() -> [Date] {
        var d = self.dates
        
        d = removePast(dates: d)
        
        let future = loadFuture(dates: d)
        d.append(contentsOf: future)
        
        self.index -= 3
        
        return d
    }
    
    func loadPast(dates: [Date]) -> [Date] {
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: dates.first!)
        
        let past = generateDays(for: monthAgo!)
    
        return past
    }
    
    func loadFuture(dates: [Date]) -> [Date] {
        let monthLater = calendar.date(byAdding: .month, value: 1, to: dates.last!)
        
        let future = generateDays(for: monthLater!)
        
        return future
    }

    private func removeFuture(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let futureNumber = generateDays(for: dates.last!).count
            
            return Array(dates[..<(dates.count - futureNumber)])
        }
        
        return dates
        
    }
    
    private func removePast(dates: [Date]) -> [Date] {
        if dates.count > 31 {
            let pastNumber = generateDays(for: dates.first!).count
            
            return Array(dates[(pastNumber)...])
        }
        
        return dates
    }
    
    private func getMonthByIndex() {
        var monthCounter: [Int: Int] = [:]
        
        for date in self.getVisibleDates() {
            monthCounter[date.get(.month), default: 0] += 1
        }
        
        var dateComponents: DateComponents? = calendar.dateComponents([.month, .year], from: Date())
        dateComponents?.month = monthCounter.max { a, b in a.value < b.value}?.key

        let date: Date? = calendar.date(from: dateComponents!)
        
        self.currentMonth = date!.monthAsString()
    }
    
    private func getVisibleDates() -> [Date] {
        let monthNum = self.index * 7
        
        let endLimit = dates[monthNum...].count >  6 ? monthNum + 6 : monthNum + dates[monthNum...].count
        
        return Array(self.dates[monthNum..<endLimit])
    }
    
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
