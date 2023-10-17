//
//  LibraryView.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 07.10.23.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    @EnvironmentObject var store: Store
    @ObservedObject var state = AppState.shared

    @Binding var selection: Set<HousePart.ID>
    
    @State private var selectMode: SelectMode = .allDeselected
    @State private var searchSavedSelection: Set<HousePart.ID> = []
    @State private var editModeSavedSelection: Set<HousePart.ID> = []

    var body: some View {
        List(selection: $selection) {
            if store.filteredHouseParts.isEmpty {
                /// Welcome side effect: removes sidebar layout glitch when moving from a populated to an empty library.
                HStack {
                    Spacer()
                    Text(isSearching ? "Empty Search Results" : "Empty Library")
                        .foregroundStyle(Color(UIColor.lightGray))
                        .italic()
                    Spacer()
                }
                .listRowBackground(Color(.secondarySystemBackground))
                .listRowSeparator(.hidden)
            } else {
                Section("Section 1") {
                    ForEach(store.filteredHouseParts) { housePart in
                        LibraryRowView(housePart: housePart, selection: $selection)
                             .listRowSeparator(.hidden)
                             .listRowBackground(Color(white: 1, opacity: 0))

                    }
                }
            }
        }
        .listStyle(.plain)
        .tint(Color(.systemPurple))
        .environment(\.editMode, $state.editMode)

        .onChange(of: isSearching) { isSearching in
            if isSearching {
                if state.editMode == .inactive {
                    searchSavedSelection = selection
                    selection = []
                }
            } else {
                if selection.isEmpty && state.editMode == .inactive {
                    if searchSavedSelection.isSubset(of: store.houseParts.map { $0.id }) {
                        selection = searchSavedSelection
                    }
                }
                if selection.count == store.filteredHouseParts.count {
                    selectMode = .allSelected
                } else {
                    selectMode = .allDeselected
                }
            }
        }
        .onChange(of: selection) { selection in
            if state.editMode == .inactive {
                editModeSavedSelection = selection
            }
            if isSearching && !selection.isEmpty && state.editMode == .inactive {
                dismissSearch()
            }
            
            if state.editMode == .active {
                if selection.count == store.filteredHouseParts.count {
                    selectMode = .allSelected
                } else {
                    selectMode = .allDeselected
                }
            }
        }
        .onChange(of: state.editMode) { editMode in
            if editMode == .inactive {
                /// Switch back to non-editMode, restore selection.
                if editModeSavedSelection.isSubset(of: store.houseParts.map { $0.id }) {
                    /// Saved selected item has not been deleted during editMode.
                    selection = editModeSavedSelection
                }
            }
        }
        .onChange(of: store.houseParts.count) { _ in
            if !selection.isSubset(of: store.houseParts.map { $0.id }) {
                /// Selected item(s) have been deleted.
                selection = []
            }
        }
        .onChange(of: state.onSubmitSearch) { submit in
            if submit {
                self.dismissSearch()
                state.onSubmitSearch = false
            }
        }
//        .toolbar(removing: state.editMode == .active ? .sidebarToggle : nil)  // iOS 17 only
        .toolbar {
            if state.showToolbarItems {
                /// To work around a bug that removes toolbar items when app moves to background in iOS 17.
                
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack(spacing: 0) {
                        if state.editMode == .active {
                            SelectAllButton(mode: $selectMode) { selectOrDeselectAll() }
                            DeleteButton { deleteSelectedItems(selection) }
                                .disabled(selection.isEmpty)
                        }
                        CustomEditButton(editMode: $state.editMode, selectMode: $selectMode)
                    }
                    .transaction { $0.animation = nil}
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func selectOrDeselectAll() {
        if selectMode == .allDeselected {
            selection = Set(store.filteredHouseParts.map { $0.id })
        } else {
            selection = []
        }
    }
    
    private func deleteSelectedItems(_ selection: Set<HousePart.ID>) {
        withAnimation {
            self.selection = []
            store.houseParts.removeAll { selection.contains($0.id) }
        }
    }
}

#Preview {
    struct StatefulContainer: View {
        @State var housePartID: Set<HousePart.ID> = 
            Set(arrayLiteral: HousePart(name: "House", docText: ["Wall"]).id)
        
        var body: some View {
            LibraryView(selection: $housePartID)
        }
    }
    return StatefulContainer()
        .environmentObject(Store())
}
