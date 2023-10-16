//
//  AppState.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 09.10.23.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    static var shared = AppState()
    init() { }
        
    @Published var editMode: EditMode = .inactive
    @Published var showToolbarItems: Bool = true
    @Published var onSubmitSearch: Bool = false
}
