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
        ZStack(alignment: .leading) {
            housePartView
            selectionIndicatorView
                .opacity(state.editMode == .inactive ? 0.0 : 1.0)
                .offset(x: state.editMode == .inactive ? -40 : 0)
                .clipped()
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
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

        .listRowBackground(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .padding(.top, 3)
                .padding(.bottom, 3)
        )
        
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

    private var backgroundColor: Color {
        if state.editMode == .inactive {
            return selection.contains(housePart.id) ?
            Color.purple.opacity(0.6) :
            Color(.libRowBGColorLight)
        } else {
            return selection.contains(housePart.id) ?
            Color(.systemGray2).opacity(0.6) :
            Color(.libRowBGColorLight)
        }
    }
    
    private var selectionIndicatorView: some View {
        ZStack {
            Image(systemName: "checkmark.circle.fill").font(.title2)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .purple)
                .padding(.trailing, 5)
                .opacity(selection.contains(housePart.id) ? 1.0 : 0.0)
            Image(systemName: "circle").font(.title2)
                .foregroundStyle(Color(.systemGray2))
                .padding(.trailing, 5)
                .opacity(selection.contains(housePart.id) ? 0.0 : 1.0)
        }
    }
    
    private var housePartView: some View {
        HStack {
            if state.editMode == .active {
                Image(systemName: "circle")
                    .font(.title2)
                    .foregroundStyle(Color(.systemGray2))
                    .padding(.trailing, 5)
                    .opacity(0.01)
            }
            VStack(alignment: .leading) {
                Text("\(housePart.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.bottom, 3)
                Text(housePart.name)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.primary)
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
    .background(Color.yellow)
}
