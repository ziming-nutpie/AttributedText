//
//  AttributedText.swift
// 
//
//  Created by Ziming Liu on 5/5/2024.
//  Copyright © 2024 Nut AI. All rights reserved.
//

import SwiftUI


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

    public init(_ stringKey: String = "",
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

#Preview("Multiple Styles") {
    AttributedText("Bold ") { text in
        text.font = .system(size: 18, weight: .bold)
    }
    +
    AttributedText("Italic ") { text in
        text.font = .system(size: 18, weight: .medium).italic()
    }
    +
    AttributedText("Colored") { text in
        text.foregroundColor = .blue
        text.underlineStyle = .single
    }
}

#Preview("Interactive") {
    AttributedText("Click ")
        +
    AttributedText("here") { text in
        text.foregroundColor = .blue
        text.underlineStyle = .single
    }
    .onTap {
        print("Link tapped!")
    }
        +
    AttributedText(" to see more")
}

#Preview("With Background") {
    AttributedText("Hello ") { text in
        text.backgroundColor = .yellow
    }
    +
    AttributedText("World") { text in
        text.backgroundColor = .green
        text.foregroundColor = .white
        text.font = .system(size: 20, weight: .bold)
    }
    +
    AttributedText("!") { text in
        text.backgroundColor = .blue
        text.foregroundColor = .white
    }
}

#Preview("Complex") {
    AttributedText("Welcome to ") { text in
        text.foregroundColor = .gray
    }
        +
    AttributedText("AttributedText") { text in
        text.foregroundColor = .blue
        text.font = .system(size: 20, weight: .bold)
    }
        +
    AttributedText("! ") { text in
        text.foregroundColor = .gray
    }
        +
    AttributedText("Try it") { text in
        text.foregroundColor = .green
        text.underlineStyle = .single
    }
    .onTap {
        print("Try it tapped!")
    }
        +
    AttributedText(" now.") { text in
        text.foregroundColor = .gray
    }
}
