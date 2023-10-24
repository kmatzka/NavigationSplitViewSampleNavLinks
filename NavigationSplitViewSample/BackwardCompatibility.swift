//
//  BackwardCompatibility.swift
//  NavigationSplitViewSample
//
//  Created by Klaus Matzka on 24.10.23.
//

import SwiftUI

@available(iOS, deprecated: 17, message: "Use SwiftUI native version in iOS 17+")
public enum ToolbarDefaultItemKind {
    case sidebarToggle
    case none
    
    @available(iOS 17, *)
    var swiftUIValue: SwiftUI.ToolbarDefaultItemKind {
        switch self {
        case .sidebarToggle:
            return .sidebarToggle
        case .none:
            return .sidebarToggle
        }
    }
}

extension View {
    @available(iOS, deprecated: 17, message: "Use SwiftUI native version in iOS 17+")
    @ViewBuilder
    public func toolbar(removing: ToolbarDefaultItemKind) -> some View {
        if #available(iOS 17, *) {
            switch removing {
            case .sidebarToggle:
                toolbar(removing: removing.swiftUIValue)
            case .none:
                toolbar(removing: nil)
            }
        } else {
            modifier(EmptyModifier())
        }
    }
}
