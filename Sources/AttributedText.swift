//
//  AttributedText.swift
// 
//
//  Created by Ziming Liu on 5/5/2024.
//  Copyright © 2024 Nut AI. All rights reserved.
//

import SwiftUI

/// `AttributedText` is a SwiftUI view component designed to render text with custom attributes and optional interactive behaviors.
/// This class supports detailed customization for each character within the text, handles tap actions, and dynamically adjusts
///
/// - Notes:
///   - If using the `.underline()` modifier, it's important to specify the underline color explicitly to ensure visibility and style consistency.
///     For example, you would use `.underline(color: .blue)` to apply a blue underline.
public struct AttributedText: View {
    private var attributedString: AttributedString
    private var onTap: (() -> Void)? = nil
    private var tapHandlers: [String: () -> Void] = [:]
    private var currentId: Int = 0
    
    private mutating func registerTapHandler(_ handler: @escaping () -> Void) -> String {
        let id = "tappable-\(currentId)"
        currentId += 1
        tapHandlers[id] = handler
        return id
    }
    
    private func getTapHandler(for id: String) -> (() -> Void)? {
        return tapHandlers[id]
    }

    init(_ stringKey: String,
         modifier: ((_ text: inout AttributedString) -> Void)? = nil,
         onTap: (() -> Void)? = nil) {
        var attributedString = AttributedString(stringKey)
        modifier?(&attributedString)
        self.attributedString = attributedString
        self.onTap = onTap
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        var result = lhs
        var rhsString = rhs.attributedString
        
        if let onTap = rhs.onTap {
            let id = result.registerTapHandler(onTap)
            rhsString.link = URL(string: "tappable://\(id)")
        }
        
        result.attributedString.append(rhsString)
        return result
    }
    
    public var body: some View {
        Text(attributedString)
            .environment(\.openURL, OpenURLAction { url in
                if let id = url.host {
                    getTapHandler(for: id)?()
                }
                return .discarded
            })
    }

    public func onTap(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy.onTap = action
        return copy
    }
}

#Preview {
    Group {
        AttributedText("Test ")
        
        +
        
        AttributedText("Tappable Text") { text in
            text.foregroundColor = .green
        }
        .onTap {
            print("Test")
        }
        
        +
        
        AttributedText(" Short")

    }
    .font(.system(size: 28))
    
}
