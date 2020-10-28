//
//  Formatter.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 28.10.2020.
//

import Foundation

func getFormatter(style: DateFormatter.Style) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = style
    
    return formatter
}
