//
//  AnyIdentifiable.swift
//
//
//  Created by Ziming Liu on 30/5/2024.
//

import Foundation
struct AnyIdentifiable: Identifiable, Equatable {
    static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID()
    var base: Any
}
