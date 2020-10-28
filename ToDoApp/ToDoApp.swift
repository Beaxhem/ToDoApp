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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let partialSheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(DatabaseManager())
                .environmentObject(partialSheetManager)
        }
    }
}

