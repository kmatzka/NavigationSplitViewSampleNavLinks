//
//  NavigationSplitViewSampleApp.swift
//  NavigationSplitViewSample
//
//  Created by Klaus Matzka on 16.10.23.
//

import SwiftUI

@main
struct NavigationSplitViewSampleApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    var state = AppState.shared
    
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .automatic
    
    var body: some Scene {
        WindowGroup {
            MainView(splitViewVisibility: $splitViewVisibility)
                .tint(Color(.systemPurple))
                .onChange(of: scenePhase) { scenePhase in
                    switch scenePhase {
                    case .background:
                        print(".background")
                    case .inactive:
                        print(".inactive")
                        /// Workaround for iOS17 bug that removes toolbar items when moving to background.
                        state.showToolbarItems = false
                        state.editMode = .inactive
                        splitViewVisibility = .detailOnly
                    case .active:
                        print(".active")
                        state.showToolbarItems = true
                    @unknown default:
                        print("unknown scenePhase")
                        fatalError()
                    }
                }
        }
    }
}
