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

#if os(macOS)

extension EventModifiers {

    var modifierFlags: NSEvent.ModifierFlags {
        var modifierFlags = NSEvent.ModifierFlags()
        for eventModifier in Array(arrayLiteral: self) {
            switch eventModifier {
            case .capsLock:
                modifierFlags.insert(.capsLock)
            case .shift:
                modifierFlags.insert(.shift)
            case .control:
                modifierFlags.insert(.control)
            case .option:
                modifierFlags.insert(.option)
            case .command:
                modifierFlags.insert(.command)
            case .numericPad:
                modifierFlags.insert(.numericPad)
            case .function:
                modifierFlags.insert(.function)
            default:
                continue
            }
        }
        return modifierFlags
    }

}

#endif
