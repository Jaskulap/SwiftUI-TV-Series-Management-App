//
//  Settings.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    @Published var kolorTla: Color = Color.black
    @Published var kolorNapisow: Color = Color.white
    @Published var kolorTlaSwitched: Bool = true {
        didSet {
            kolorTla = kolorTlaSwitched ? Color.black : Color.white
            kolorNapisow = kolorTlaSwitched ? Color.white : Color.black
        }
    }
}

