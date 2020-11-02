//
//  CreateCategoryView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 02.11.2020.
//

import SwiftUI
import PartialSheet

struct CreateCategoryView: View {
    @State var title = ""
    @State private var selectedColor = Color.black
    
    @EnvironmentObject var sheetManager: PartialSheetManager
    
    var body: some View {
        VStack {
            Text("Title")
            
            TextField("", text: $title)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            
            ColorPicker(
                "Pick a color",
                selection: $selectedColor
            )
            
            Button(action: { createCategory() }) {
                Text("Create category")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top)
            
        }.padding()
    }
    
    private func createCategory() {
        let category = Category()
        let color = selectedColor.getHex()
        
        category.name = title
        category.color = color
        
        do {
            try DatabaseManager.shared.saveToDatabase(object: category)
            sheetManager.showPartialSheet {
                AddTaskView()
            }
        } catch let error {
            print(error)
        }
        
        
        
    }
}

struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategoryView()
    }
}
