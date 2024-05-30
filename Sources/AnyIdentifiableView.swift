//
//  AnyIdentifiableView.swift
//
//
//  Created by Ziming Liu on 30/5/2024.
//

import SwiftUI
struct AnyIdentifiableView: View, Identifiable, Equatable {
    static func == (lhs: AnyIdentifiableView, rhs: AnyIdentifiableView) -> Bool {
        lhs.id == rhs.id
    }
    
    public var base: any View
    public var id = UUID()
    init(_ base: AnyView) {
        self.base = base
    }
    var body: some View {
        base.wrappedToAnyView()
    }
}
