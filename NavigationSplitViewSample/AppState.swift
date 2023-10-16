//
//  AppState.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 09.10.23.
//

import Foundation
import SwiftUI

enum CustomEditMode {
    case inactive, active
}

class AppState: ObservableObject {
    static var shared = AppState()
    init() { }
        
    @Published var editMode: CustomEditMode = CustomEditMode.inactive
    @Published var showToolbarItems: Bool = true
    @Published var onSubmitSearch: Bool = false
}
