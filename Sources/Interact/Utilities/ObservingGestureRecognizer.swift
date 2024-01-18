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

#if os(macOS)

import AppKit

class ObservingGestureRecognizer: NSGestureRecognizer {

    var onRightMouseDown: (() -> Void)?

    init(onRightMouseDown: @escaping () -> Void) {
        super.init(target: nil, action: nil)
        self.onRightMouseDown = onRightMouseDown
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func rightMouseDown(with event: NSEvent) {
        defer { self.state = .failed }
        guard let view = view else {
            return
        }
        let mouseLocation = view.convert(event.locationInWindow, from: nil)
        guard view.bounds.contains(mouseLocation) else {
            return
        }
        if let onRightMouseDown = onRightMouseDown {
            onRightMouseDown()
        }
        super.rightMouseDown(with: event)
    }

}

#endif
