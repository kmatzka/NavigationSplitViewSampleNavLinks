//
//  MainView.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 09.10.23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @StateObject var store = Store()
    @ObservedObject var state = AppState.shared
    
    @Binding var splitViewVisibility: NavigationSplitViewVisibility
    
    @State private var selection: Set<HousePart.ID> = []
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            LibraryView(selection: $selection)
                .searchable(text: $store.housePartsFilter)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit(of: .search) {
                    /// To be able to trigger .dismissSearch() in .searchable child view
                    state.onSubmitSearch = true
                }
                .onDisappear {
                    if hSizeClass == .regular {
                        /// In .compact size class we are removing NavSplitView for a NavStack
                        /// In that case, we must not end editMode!
                        state.editMode = .inactive
                    }
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Library")
        } detail: {
            if state.editMode == .inactive {
                if let housePartID = selection.first {
                    DetailView(housePartID: housePartID)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(store.housePart(id: housePartID)?.name ?? " ")
                } else {
                    Text("Select a HousePart.")
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(" ")
                }
            } else {
                ZStack {
                    Color.clear /// Grabs all space available.
                    Text("Select a HousePart.")
                        .foregroundStyle(.thinMaterial)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(" ")
                }
                .contentShape(Rectangle())  /// Make sure all of Color.clear is tap-able.
                .onTapGesture {
                    state.editMode = .inactive
                    state.onSubmitSearch = true
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .environmentObject(store)
    }
}

#Preview {
    MainView(splitViewVisibility: .constant(.all))
}
