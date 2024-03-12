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

extension Collection {

    public func map<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
        return try await withThrowingTaskGroup(of: T.self) { group in
            for element in self {
                group.addTask {
                    return try await transform(element)
                }
            }
            var items = [T]()
            for try await item in group {
                items.append(item)
            }
            return items
        }
    }

    public func forEach(_ perform: @escaping (Element) async throws -> Void) async rethrows {
        return try await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try await perform(element)
                    return ()
                }
            }
            try await group.waitForAll()
        }
    }

}

extension Array {

    public func map<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
        return try await withThrowingTaskGroup(of: T.self) { group in
            for element in self {
                group.addTask {
                    return try await transform(element)
                }
            }
            var items = [T]()
            for try await item in group {
                items.append(item)
            }
            return items
        }
    }

    public func compactMap<T>(_ transform: @escaping (Element) async throws -> T?) async rethrows -> [T] {
        return try await withThrowingTaskGroup(of: T?.self) { group in
            for element in self {
                group.addTask {
                    return try await transform(element)
                }
            }
            var items = [T]()
            for try await item in group {
                guard let item else {
                    continue
                }
                items.append(item)
            }
            return items
        }
    }

}
