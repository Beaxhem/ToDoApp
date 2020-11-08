//
//  DateIndicator.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 08.11.2020.
//

import SwiftUI

struct DateIndicator: View {
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(formatDate(date: date))
                .font(.caption)
            
            Text("Today")
                .bold()
                .font(.title)
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = getFormatter(style: .medium)
        return formatter.string(from: date)
    }
}

struct DateIndicator_Previews: PreviewProvider {
    static var previews: some View {
        DateIndicator(date: .constant(Date()))
    }
}
