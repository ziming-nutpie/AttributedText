//
//  Builder.swift
//  
//
//  Created by Ziming Liu on 30/5/2024.
//

import SwiftUI

@resultBuilder
public struct CustomViewBuilder {
    public static func buildBlock(_ components: any View...) -> [any View] {
        return components
    }
}
