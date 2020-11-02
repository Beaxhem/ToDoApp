//
//  OptionView.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 02.11.2020.
//

import SwiftUI

struct OptionView: View {
    var option: Option
    
    var body: some View {
        Text(option.title)
            .background(Color.white)
            .border(Color.gray, width: 1)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(option: Option())
    }
}
