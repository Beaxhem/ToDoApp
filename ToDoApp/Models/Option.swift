//
//  Option.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 02.11.2020.
//

import SwiftUI

class Option {
    var title: String = ""
}

protocol Optionable: Identifiable {
    var id: UUID { get set }
    func asOption() -> Option
}
