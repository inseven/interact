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

//extension Gesture {
//
//    public static func onClick(perform: @escaping ClickCompletion) -> _EndedGesture<TapGesture> {
//        return TapGesture()
//            .onEnded(perform)
//    }
//
//    public static func onDoubleClick(perform: @escaping ClickCompletion) -> _EndedGesture<TapGesture> {
//        TapGesture(count: 2).onEnded(perform)
//    }
//
//    public func onDoubleClick(perform: @escaping ClickCompletion) -> SequenceGesture<Self, _EndedGesture<TapGesture>> {
//        TapGesture(count:2)
//            .sequenced(before: self)
//        sequenced(before: TapGesture(count: 2)
//                    .onEnded(perform))
//    }
//
//    public func onShiftClick(perform: @escaping ClickCompletion) -> some Gesture {
//        sequenced(before: TapGesture(count: 1)
//                    .modifiers(EventModifiers.shift)
//                    .onEnded(perform))
//    }
//
//    public func onCommandClick(perform: @escaping ClickCompletion) -> some Gesture {
//        sequenced(before: TapGesture(count: 1)
//                    .modifiers(EventModifiers.command)
//                    .onEnded(perform))
//    }
//
//    public func onCommandDoubleClick(perform: @escaping ClickCompletion) -> some Gesture {
//        sequenced(before: TapGesture(count: 2)
//                    .modifiers(EventModifiers.command)
//                    .onEnded(perform))
//    }
//
//}

public typealias ClickCompletion = () -> Void

extension View {

    public func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }

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

}
