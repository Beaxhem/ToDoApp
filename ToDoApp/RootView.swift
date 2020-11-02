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
                    Image(systemName: "list.bullet")
                    Text("My tasks")
                }
                .tag(0)
            
            TasksView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Dashboard")
                }
                .tag(0)
        }
        .accentColor(.red)
        .addPartialSheet()
    }
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
