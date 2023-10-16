//
//  EditSelectDeleteButtons.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 08.10.23.
//

import SwiftUI

struct CustomEditButton: View {
    @Binding var editMode: EditMode
    @Binding var selectMode: SelectMode
    
    var cleanUpAction: () -> Void = {}
    var prepareEditMode: () -> Void = {}
    
    var body: some View {
        Button {
            withAnimation {
                if editMode == .active {
                    editMode = .inactive
                    cleanUpAction()
                } else {
                    selectMode = .allDeselected
                    editMode = .active
                    prepareEditMode()
                }
            }
        } label: {
            if editMode == .active {
                Text("Done").bold()
            } else {
                Text("Edit")
            }
        }
    }
}

enum SelectMode {
    case allSelected, allDeselected
    
    var isActive: Bool {
        self == .allSelected
    }
    
    mutating func toggle() {
        switch self {
        case .allSelected:
            self = .allDeselected
        case .allDeselected:
            self = .allSelected
        }
    }
}

struct SelectAllButton: View {
    @Binding var mode: SelectMode
    
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
            mode.toggle()
        } label: {
            Text(mode.isActive ? "Deselect All" : "Select All")
        }
    }
}

struct DeleteButton: View {
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .keyboardShortcut(.delete, modifiers: [])
    }
}
