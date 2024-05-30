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
    private var id = 0
    private var dataSource: [Self] = []
    private var string: String
    private var onTap: (() -> Void)? = nil
    private var modifier: (Text) -> AnyView
    @State
    private var maxWidth: CGFloat = 0
    @State
    private var contentWidth: CGFloat = 0
    
    init(_ stringKey: String,
         modifier: @escaping (Text) -> some View = { _ in EmptyView()},
         onTap: (() -> Void)? = nil) {
        self.string = stringKey.localized()
        self.onTap = onTap
        self.modifier = {
            if modifier($0) is EmptyView {
                return $0.wrappedToAnyView()
            } else {
                return modifier($0).wrappedToAnyView()
            }
        }

        self.prepareDataSource()
    }
    
    private mutating func prepareDataSource() {
        //Untappable string should be broken into a new line
        var dataSource = [Self]()
        for character in self.string {
            var newText = self
            newText.string = String(character)
            dataSource.append(newText)
        }
        
        self.dataSource = dataSource
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        var copy = lhs
        copy.dataSource.append(contentsOf: rhs.dataSource)
        
        var newDataSource = [Self]()
        for var (index, auttributedText) in copy.dataSource.enumerated() {
            auttributedText.id = index
            newDataSource.append(auttributedText)
        }
        copy.dataSource = newDataSource
        return copy
    }
    
    @ViewBuilder
    var sizeReader: some View {
        ZStack {
            Color.red.frame(maxWidth: .infinity)
                .readSize { size in
                    print("Max width is \(size.width)")
                    self.maxWidth = size.width
                }
            
            HStack(spacing: 0) {
                ForEach(dataSource, id: \.string) {
                    self.buildText(by: $0)
                }
            }
            .readSize { size in
                print("Content width is \(size.width)")
                self.contentWidth = size.width
            }
            .overlay {
                Color.green
            }
        }
        .frame(maxHeight: 0)
        .opacity(0)
    }
    
    @ViewBuilder
    var content: some View {
        if contentWidth.rounded() >= maxWidth.rounded() {
            FlexibleLinesView(dataSource: dataSource) {
                self.buildText(by: $0)
            }
            .padding(horizontal: 0)
        } else {
            HStack(spacing: 0) {
                ForEach(dataSource, id: \.id) {
                    self.buildText(by: $0)
                }
            }
        }
    }
    
    public var body: some View {
        sizeReader
            .overlay {
                content
            }
    }
    
    @ViewBuilder
    private func buildText(by AttributedText: Self) -> some View {
        let textView = AttributedText.string != " " ?
        Text(AttributedText.string) :
        Text(".").foregroundColor(.clear)
        
        if let onTap = AttributedText.onTap {
            Button {
                onTap()
            } label: {
                AttributedText.modifier(textView)
                    .fixedSize(horizontal: true, vertical: false)
            }
          
        } else {
            AttributedText.modifier(textView)
        }
    }
    
    ///Rendering as a whole will not break the text into new lines
    func asAWhole() -> Self {
        var copy = self
        copy.dataSource = [copy]
        return copy
    }
}

#Preview {
    AttributedText("Test ") {
        $0.foregroundColor(.black)
    }
    
    +
    
    AttributedText("Tappable Text") {
        $0.foregroundColor(.blue)
            .underline(color: .blue)
    } onTap: {
        print("Tap me")
    }
    
    +
    
    AttributedText(" Short") {
        $0.foregroundColor(.black)
    }
}

#Preview {
    AttributedText("This is a ") {
        $0.foregroundColor(.black)
    }
    
    +
    
    AttributedText("Tappable Text") {
        $0.foregroundColor(.blue)
    } onTap: {
        print("Tap me")
    }
  
    
    +
    
    AttributedText(" Testing, it can be wrapped to a new line, and it is very cool!") {
        $0.foregroundColor(.black)
    }
}

#Preview {
    AttributedText("Testing, the tappable text will not be splited ") {
        $0.foregroundColor(.black)
    }
    
    +
    
    AttributedText("Tappable Text (As a whole)") {
        $0.foregroundColor(.blue)
    } onTap: {
        print("Tap me")
    }
    .asAWhole()
    
    +
    
    AttributedText(" Yes") {
        $0.foregroundColor(.black)
    }
}

#Preview {
    AttributedText("Testing, the tappable text will not be splited ") {
        $0.foregroundColor(.black)
    }
    
    +
    
    AttributedText("Tappable Text") {
        $0.foregroundColor(.blue)
    } onTap: {
        print("Tap me")
    }
    
    +
    
    AttributedText(" Yes") {
        $0.foregroundColor(.black)
    }
}

