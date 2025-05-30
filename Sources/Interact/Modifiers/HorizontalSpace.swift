// Copyright (c) 2018-2025 Jason Morley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI

public struct HorizontalSpace: ViewModifier {

    public struct Edge: OptionSet {
        public let rawValue: UInt

        /// Add a leading space.
        public static let leading = Edge(rawValue: 1 << 0)

        /// Add a trailing space.
        public static let trailing = Edge(rawValue: 1 << 1)

        /// Add both leading and trailing spaces.
        public static let both: Edge = [.leading, .trailing]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }

    var edges: Edge = .both

    public init(_ edges: Edge) {
        self.edges = edges
    }

    public func body(content: Content) -> some View {
        HStack {
            if edges.contains(.leading) {
                Spacer()
            }
            content
            if edges.contains(.trailing) {
                Spacer()
            }
        }
    }

}

public extension View {

    func horizontalSpace(_ edges: HorizontalSpace.Edge) -> some View {
        return modifier(HorizontalSpace(edges))
    }

}
