//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 29.10.2020.
//

import SwiftUI
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {

                }
            })

        Realm.Configuration.defaultConfiguration = config
        return true
    }
}

