//
//  Store.swift
//  NavigationSplitView4
//
//  Created by Klaus Matzka on 07.10.23.
//

import Foundation

class Store: ObservableObject {
    @Published var houseParts: [HousePart] = [
        HousePart(name: "House", docText: ["Wall 1", "Wall 2", "Roof 3", "Cellar 4"]),
        HousePart(name: "Car", docText: ["Wheel 1", "Wheel 2", "Windscreen 3", "Battery 4", "Trunk", "Steering wheel"]),
        HousePart(name: "Garden", docText: ["Bush", "Tree", "Grass", "Hedge", "Roses"])
    ]
    
    @Published var housePartsFilter: String = ""
    
    var filteredHouseParts: [HousePart] {
        housePartsFilter.isEmpty ? 
        houseParts :
        houseParts.filter( { $0.name.lowercased().contains(housePartsFilter.lowercased()) })
    }
    
    func housePart(id: UUID?) -> HousePart? {
        houseParts.first(where: { $0.id == id })
    }
}
