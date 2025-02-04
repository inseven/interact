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

public typealias ClickCompletion = () -> Void

extension View {

    public func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }

    public func handlesExternalEvents(preferring: Set<URL>, allowing: Set<URL>) -> some View {
        return handlesExternalEvents(preferring: Set(preferring.map { $0.absoluteString }),
                                     allowing: Set(allowing.map { $0.absoluteString }))
    }

    public func presents(_ error: Binding<Error?>) -> some View {
        return alert(isPresented: error.bool()) {
            Alert(error: error.wrappedValue)
        }
    }

    @available(macOS 13, *)
    public func allowsApplicationTerminationWhenModal() -> some View {
#if os(macOS)
        hookWindow { window in
            window.preventsApplicationTerminationWhenModal = false
        }
#else
        return self
#endif
    }

    @available(iOS 15.0, *, macOS 13.0, *)
    public func searchable() -> some View {
        return self
            .searchable(text: Binding.constant(""))
            .disabled(true)
    }

#if os(macOS)

    public func handleMouse(click: @escaping ClickCompletion,
                            doubleClick: @escaping ClickCompletion = {},
                            shiftClick: @escaping ClickCompletion = {},
                            commandClick: @escaping ClickCompletion = {}) -> some View {
        gesture(TapGesture()
                    .modifiers(.command)
                    .onEnded(commandClick)
                    .exclusively(before: TapGesture()
                                    .modifiers(.shift)
                                    .onEnded(shiftClick))
                    .exclusively(before:
                                    TapGesture()
                                    .onEnded(click)
                                    .simultaneously(with: TapGesture(count: 2)
                                                        .onEnded(doubleClick))))
    }

#endif

#if os(iOS)

    @available(iOS 15.0, *)
    public func defaultFocus<V>(_ focus: FocusState<V>.Binding, _ value: V) -> some View {
        return onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focus.wrappedValue = value
            }
        }
    }

#endif

}
