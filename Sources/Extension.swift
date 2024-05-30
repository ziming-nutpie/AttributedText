//
//  File.swift
//  
//
//  Created by Ziming Liu on 30/5/2024.
//

import SwiftUI

extension View {
    func wrappedToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func wrappedToAnyIdentifiableView() -> AnyIdentifiableView {
        return AnyIdentifiableView(self.wrappedToAnyView())
    }
    
    func readSize(_ callback: @escaping (_ size: CGSize) -> Void) -> some View {
        self.background {
            GeometryReader { g in
                Color.clear.onAppear {
                    callback(g.size)
                }
            }
        }
    }
}

extension String {
    func localized() -> String {
        NSLocalizedString(self, value: self, comment: "")
    }
}
