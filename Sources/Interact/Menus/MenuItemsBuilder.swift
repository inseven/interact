// Copyright (c) 2018-2024 Jason Morley
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

import Foundation

@available(iOS 15, *, macOS 12, *)
public protocol MenuItemsConvertible {
    func asMenuItems() -> [MenuItem]
}

@available(iOS 15, *, macOS 12, *)
@resultBuilder public struct MenuItemBuilder {

    public static func buildBlock() -> [MenuItem] {
        return []
    }

    public static func buildBlock(_ items: MenuItem...) -> [MenuItem] {
        return items
    }

    public static func buildBlock(_ values: MenuItemsConvertible...) -> [MenuItem] {
        return values
            .flatMap { $0.asMenuItems() }
    }

    public static func buildIf(_ value: MenuItemsConvertible?) -> MenuItemsConvertible {
        return value ?? []
    }

    public static func buildEither(first: MenuItemsConvertible) -> MenuItemsConvertible {
        first
    }

    public static func buildEither(second: MenuItemsConvertible) -> MenuItemsConvertible {
        second
    }

}

@available(iOS 15, *, macOS 12, *)
extension Array: MenuItemsConvertible where Element == MenuItem {

    public func asMenuItems() -> [MenuItem] {
        return self
    }

}
