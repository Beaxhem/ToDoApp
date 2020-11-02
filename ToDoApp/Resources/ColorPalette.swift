//
//  ColorPalette.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 01.11.2020.
//

import SwiftUI

extension Color {
    static let backgroundColor = Color("backgroundColor")
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func getHex() -> String {
        let colorString = "\(self)"
        let colorArray: [String] = colorString.components(separatedBy: " ")

        if colorArray.count > 1 {
            var r: CGFloat = CGFloat((Float(colorArray[1]) ?? 1))
            var g: CGFloat = CGFloat((Float(colorArray[2]) ?? 1))
            var b: CGFloat = CGFloat((Float(colorArray[3]) ?? 1))

            if (r < 0.0) {r = 0.0}
            if (g < 0.0) {g = 0.0}
            if (b < 0.0) {b = 0.0}

            if (r > 1.0) {r = 1.0}
            if (g > 1.0) {g = 1.0}
            if (b > 1.0) {b = 1.0}

            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "#%06X", rgb)
        }
        
        return "#000000"
    }
}

