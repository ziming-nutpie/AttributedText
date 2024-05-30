//
//  FlexibleLinesView.swift
// 
//
//  Created by Ziming Liu on 28/8/2023.
//  Copyright © 2024 Nut AI. All rights reserved.

import Foundation
import SwiftUI

struct FlexibleLinesView: View {
    private var dataSource: [AnyIdentifiable] = []
    private var views: [AnyIdentifiableView] = []
    private var content: ((AnyIdentifiable) -> AnyView)? =  nil
    private var padding_horizontal: CGFloat = 4
    private var padding_vertical: CGFloat = 4
    @State private var totalHeight: CGFloat = 0

    var body: some View {
        VStack {
            GeometryReader { geometry in
                if !dataSource.isEmpty {
                    generateContentForDataSource(in: geometry)
                } else {
                    generateContentForViews(in: geometry)
                }
               
            }
        }
        .frame(height: totalHeight)
    }

    @ViewBuilder
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
    
    func padding(horizontal: CGFloat = 4, vertical: CGFloat = 4) -> Self {
        var copy = self
        copy.padding_vertical = vertical
        copy.padding_horizontal = horizontal
        return copy
    }

}

extension FlexibleLinesView {
    init(@CustomViewBuilder content: @escaping () -> [any View]) {
        views = content().map {
            $0.wrappedToAnyIdentifiableView()
        }
    }
    
    @ViewBuilder
    private func generateContentForViews(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        ZStack(alignment: .topLeading) {
            ForEach(views) { view in
                view
                    .padding(.horizontal, padding_horizontal)
                    .padding(.vertical, padding_vertical)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if view == self.views.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if view == self.views.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
}
extension FlexibleLinesView {
    init<Data, Content: View>(dataSource: [Data], @ViewBuilder content: @escaping (Data) -> Content) {
        self.dataSource = dataSource.map { AnyIdentifiable(base: $0) }
        self.content = { data in
            content(data.base as! Data).wrappedToAnyView()
        }
    }
    
    @ViewBuilder
    private func generateContentForDataSource(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        ZStack(alignment: .topLeading) {
            ForEach(dataSource) { data in
                content?(data)
                    .padding(.horizontal, padding_horizontal)
                    .padding(.vertical, padding_vertical)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if data == self.dataSource.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if data == self.dataSource.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
}

struct FlexibleLinesView_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleLinesView(dataSource: ["A",
                                     "AB",
                                     "ABC",
                                     "ABCD",
                                     "ABCDE",
                                     "ABCDEF",
                                     "ABCDEFG"]) { data in
            Text(data)
        }
        
        FlexibleLinesView {
            Text("A")
            Text("B")
        }
    }
}
