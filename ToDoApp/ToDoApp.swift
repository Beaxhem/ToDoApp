//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI
import PartialSheet

@main
struct ToDoApp: App {
    var body: some Scene {
        let partialSheetManager = PartialSheetManager()
        
        WindowGroup {
            RootView()
                .environmentObject(DatabaseManager())
                .environmentObject(partialSheetManager)
        }
    }
}
