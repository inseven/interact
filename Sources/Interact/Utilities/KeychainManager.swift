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

public struct KeychainManager<Key: RawRepresentable> where Key.RawValue == String {

    public enum AccessPolicy {
        case whenUnlocked
        case afterFirstUnlock

        var value: CFString {
            switch self {
            case .whenUnlocked:
                return kSecAttrAccessibleWhenUnlocked
            case .afterFirstUnlock:
                return kSecAttrAccessibleAfterFirstUnlock
            }
        }
    }

    let accessGroup: String?

    public init(accessGroup: String? = nil) {
        self.accessGroup = accessGroup
    }

    func delete(key: Key) throws {
        var query: [String: Any] = [
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ]
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError(status: status)
        }
    }

    public func set(_ value: String?, forKey key: Key, accessPolicy: AccessPolicy = .whenUnlocked) throws {
        if let value {
            let data = value.data(using: .utf8)!
            var query: [String: Any] = [
                kSecAttrSynchronizable as String: kCFBooleanTrue,
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccessible as String: accessPolicy.value,
                kSecAttrAccount as String: key.rawValue,
                kSecValueData as String: data
            ]
            if let accessGroup {
                query[kSecAttrAccessGroup as String] = accessGroup
            }
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                throw KeychainError(status: status)
            }
        } else {
            try delete(key: key)
        }
    }

    public func string(forKey key: Key) throws -> String? {
        var query: [String: Any] = [
            kSecAttrSynchronizable as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw KeychainError(status: status)
        }
        guard let data = item as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

}
