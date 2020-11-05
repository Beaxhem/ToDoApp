//
//  OptionsView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 02.11.2020.
//

import SwiftUI
import PartialSheet

struct OptionsView<T: Optionable>: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    
    var options: [T]
    var title: String = "Select"
    var placeholder: String = "Options"
    
    @State var isOpened = false
    
    @Binding var selectedOption: T?
    
    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(Color(hex: (selectedOption as? Category)?.color ?? "#000000"))
                    .frame(width: 20)
                Text(title)
            }
            
            Spacer()
            Menu(selectedOption != nil ? selectedOption!.asOption().title : placeholder) {
                ForEach(options) { optionable in
                    let option = optionable.asOption()
                    
                    Button(action: {
                        self.selectedOption = optionable
                    }, label: {
                        Text(option.title)
                    })
                }
                
                Button {
                    self.sheetManager.showPartialSheet {
                        CreateCategoryView()
                    }
                } label: {
                    Image(systemName: "plus")
                    Text("Create new category")
                }

            }
        }
        
        
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(options: [Category()], selectedOption: .constant(Category()))
    }
}
