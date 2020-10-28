//
//  RootView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 27.10.2020.
//

import SwiftUI
import PartialSheet

struct RootView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .tabItem {
                    Text("My tasks")
                }
                .tag(0)
        }
        .addPartialSheet()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
