//
//  HousePart.swift
//  NavigationSplitView3
//
//  Created by Klaus Matzka on 07.10.23.
//

import Foundation

struct HousePart: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let docText: [String]
}
