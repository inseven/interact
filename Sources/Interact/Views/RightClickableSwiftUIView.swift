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

struct RightClickableSwiftUIView: NSViewRepresentable {

    var onRightClickFocusChange: (Bool) -> Void

    class Coordinator: NSObject, RightClickObservingViewDelegate {

        var parent: RightClickableSwiftUIView

        init(_ parent: RightClickableSwiftUIView) {
            self.parent = parent
        }

        func rightClickFocusDidChange(focused: Bool) {
            // TODO: Remove repeated entries here? Maybe this could be a publisher?
            parent.onRightClickFocusChange(focused)
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> RightClickObservingView {
        let view = RightClickObservingView()
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ view: RightClickObservingView, context: NSViewRepresentableContext<RightClickableSwiftUIView>) {
        view.delegate = context.coordinator
    }

}

protocol RightClickObservingViewDelegate: NSObject {

    func rightClickFocusDidChange(focused: Bool)

}

#endif
