//
//  RectCorner.swift
//  Fileaway
//
//  Created by Jason Barrie Morley on 14/02/2021.
//

import Foundation

public struct RectCorner: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let topLeft = RectCorner(rawValue: 1 << 0)
    public static let topRight = RectCorner(rawValue: 1 << 1)
    public static let bottomLeft = RectCorner(rawValue: 1 << 2)
    public static let bottomRight = RectCorner(rawValue: 1 << 3)

    public static let all: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
