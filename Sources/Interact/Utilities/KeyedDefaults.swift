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

public class KeyedDefaults<Key: RawRepresentable> where Key.RawValue == String {

    let defaults: UserDefaults

    public init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    public func bool(forKey key: Key) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }

    public func bool(forKey key: Key, default defaultValue: Bool) -> Bool {
        return (object(forKey: key) as? Bool) ?? defaultValue
    }

    public func integer(forKey key: Key) -> Int {
        return defaults.integer(forKey: key.rawValue)
    }

    public func integer(forKey key: Key, default defaultValue: Int) -> Int {
        return (object(forKey: key) as? Int) ?? defaultValue
    }

    public func object(forKey key: Key) -> Any? {
        return defaults.object(forKey: key.rawValue)
    }

    public func string(forKey key: Key) -> String? {
        return defaults.string(forKey: key.rawValue)
    }

    public func string(forKey key: Key, default defaultValue: String) -> String {
        return string(forKey: key) ?? defaultValue
    }

    public func value<T: RawRepresentable>(forKey key: Key) -> T? where T.RawValue == String {
        guard let rawValue = string(forKey: key) else {
            return nil
        }
        return T(rawValue: rawValue)
    }

    public func value<T: RawRepresentable>(forKey key: Key, default defaultValue: T) -> T where T.RawValue == String {
        return value(forKey: key) ?? defaultValue
    }

    public func codable<T: Codable>(forKey key: Key) throws -> T? {
        guard let data = object(forKey: key) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func codable<T: Codable>(forKey key: Key, default defaultValue: T) throws -> T {
        return try codable(forKey: key) ?? defaultValue
    }

    public func set(_ value: Any?, forKey key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    public func set<T: RawRepresentable>(_ value: T, forKey key: Key) where T.RawValue == String {
        defaults.set(value.rawValue, forKey: key.rawValue)
    }

    public func set<T: Codable>(codable: T, forKey key: Key) throws {
        let data = try JSONEncoder().encode(codable)
        set(data, forKey: key)
    }

}
