//
//  LibraryRowView.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 07.10.23.
//

import SwiftUI

struct LibraryRowView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var state = AppState.shared

    var housePart: HousePart
    @Binding var selection: Set<HousePart.ID>

    @State private var showConfirmationDialog: Bool = false
    @State private var itemToDelete: HousePart.ID?

    var body: some View {
        housePartView
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(selection.contains(housePart.id) ? Color(.systemPurple) : Color("ListRowBackgroundColor")).opacity(0.7)
            )
            .onTapGesture {
                if state.editMode == .active {
                    if selection.contains(housePart.id) {
                        selection.remove(housePart.id)
                    } else {
                        selection.insert(housePart.id)
                    }
                } else {
                    selection = [housePart.id]
                }
            }
        
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .none) {
                    confirmDeleteItem(housePart)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
        
            .confirmationDialog(Text("Permanentely delete this item?"),
                                isPresented: $showConfirmationDialog,
                                titleVisibility: .visible,
                                presenting: itemToDelete) { itemToDelete in
                Button("Delete", role: .destructive) {
                    deleteItem(itemToDelete)
                }
            } message: { itemToDelete in
                Text("You cannot undo deleting item '\(store.housePart(id: itemToDelete)?.name ?? "--")'?")
            }
    }
    
    // MARK: - Private
    
    private func confirmDeleteItem(_ housePart: HousePart) {
        itemToDelete = housePart.id
        showConfirmationDialog = true
    }
    
    private func deleteItem(_ item: HousePart.ID) {
        withAnimation {
            store.houseParts.removeAll { item == $0.id }
        }
    }

    private var housePartView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(housePart.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.bottom, 3)
                Text(housePart.name)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(selection.contains(housePart.id) ? .primary : Color(.systemPurple))
                Text(housePart.docText.joined(separator: ", "))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

#Preview {
    LibraryRowView(
        housePart: HousePart(name: "House", docText: ["Wall", "Roof"]),
        selection: .constant(Set(arrayLiteral: HousePart(name: "House", docText: ["Wall", "Roof"]).id))
    )
}
