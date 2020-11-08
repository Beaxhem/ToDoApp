//
//  AddTaskButtonView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 08.11.2020.
//

import SwiftUI
import PartialSheet

struct AddTaskButtonView<Content: View>: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    var content: () -> Content
    
    private let offset: CGFloat = 50
    private let size: CGFloat = 60
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content()
                
                Button(action: {
                    sheetManager.showPartialSheet {
                        AddTaskView()
                    }
                }, label: {
                    ZStack(alignment: .center) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: size, height: size)
                            .shadow(radius: 3)
                        Text("+")
                            .bold()
                            .font(.largeTitle)
                            .padding(.bottom, 3)
                            .padding(.leading, 1)
                    }
                })
                .position(x: geometry.size.width - offset, y: geometry.size.height - offset)
            }
        }
        
    }
}

struct AddTaskButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskButtonView {
            Text("Test")
        }
    }
}
