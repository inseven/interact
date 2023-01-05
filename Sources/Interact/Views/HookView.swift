// Copyright (c) 2018-2023 InSeven Limited
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

public struct HookView: NSViewRepresentable {

    struct ViewState {
        weak var nsView: NSView?
    }

    @State var viewState = ViewState()

    let action: (NSView) -> Void?

    public init(action: @escaping (NSView) -> Void?) {
        self.action = action
    }

    public func makeNSView(context: Context) -> NSView {
        return NSView(frame: .zero)
    }

    public func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            guard self.viewState.nsView != nsView else {
                return
            }
            self.viewState.nsView = nsView
            self.action(nsView)
        }
    }
}

#else

public struct HookView: UIViewRepresentable {

    struct ViewState {
        weak var uiView: UIView?
    }

    @State var viewState = ViewState()

    let action: (UIView) -> Void?

    public init(action: @escaping (UIView) -> Void?) {
        self.action = action
    }

    public func makeUIView(context: Context) -> UIView {
        return UIView(frame: .zero)
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard self.viewState.uiView != uiView else {
                return
            }
            self.viewState.uiView = uiView
            self.action(uiView)
        }
    }
}

#endif

extension View {

    public func hookView(action: @escaping (NativeView) -> Void) -> some View {
        return background(HookView(action: action))
    }

    public func hookWindow(action: @escaping (NativeWindow) -> Void) -> some View {
        return hookView { view in
            guard let window = view.window else {
                return
            }
            action(window)
        }
    }

    public func hookScale(action: @escaping (CGFloat) -> Void) -> some View {
        return hookWindow { window in
            action(window.scaleFactor)
        }
    }

}
