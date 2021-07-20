// Copyright (c) 2018-2021 InSeven Limited
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

extension View {

    public func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }

    public func onClick(_ click: @escaping () -> Void, doubleClick: @escaping () -> Void) -> some View {
        return gesture(TapGesture()
                        .onEnded(click)
                        .simultaneously(with: TapGesture(count: 2)
                                            .onEnded(doubleClick)))
    }

    public func onShiftClick(_ action: @escaping () -> Void) -> some View {
        return highPriorityGesture(TapGesture(count: 1)
                                    .modifiers(EventModifiers.shift).onEnded(action))
    }

    public func onCommandClick(_ action: @escaping () -> Void) -> some View {
        return highPriorityGesture(TapGesture(count: 1)
                                    .modifiers(EventModifiers.command).onEnded(action))
    }

    public func onCommandDoubleClick(_ action: @escaping () -> Void) -> some View {
        return highPriorityGesture(TapGesture(count: 2)
                                    .modifiers(EventModifiers.command).onEnded(action))
    }

}
