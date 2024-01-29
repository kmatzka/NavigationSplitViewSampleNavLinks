//
//  MainView.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 09.10.23.
//

import SwiftUI

struct MainView: View {
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
                    state.editMode = .inactive
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Library")
            
        } detail: {
            
            if state.editMode == .inactive {

                if let housePartID = selection.first {
                    
                    DetailView(housePartID: housePartID)
                        .id(housePartID)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(store.housePart(id: housePartID)?.name ?? " ")
                    
                        .onAppear {
                            print("    MainView detail: onAppear")
                        }
                        .onDisappear {
                            print("    MainView detail: onDisappear")
                        }
                    
                } else {
                    Text("Select a HousePart.")
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(" ")
                }

            } else {
                
                ZStack {
                    Color.clear
                    Text("Select a HousePart.")
                        .foregroundStyle(.thinMaterial)
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle(" ")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        state.editMode = .inactive
                        state.onSubmitSearch = true
                    }
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
