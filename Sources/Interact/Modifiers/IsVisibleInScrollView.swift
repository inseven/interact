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

import Combine
import SwiftUI

#if os(iOS)

struct IsVisibleInScrollView: ViewModifier {

    class ViewModel: ObservableObject {

        @Published var offset: CGFloat = 0

        private var cancellable: AnyCancellable?
        private weak var view: UIView? = nil

        @MainActor func subscribe(to view: UIView) {
            guard let scrollView = view.scrollView,
                      self.view != scrollView
            else {
                return
            }
            self.view = scrollView
            cancellable = scrollView
                .publisher(for: \.contentOffset)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] contentOffset in
                    guard let self = self else {
                        return
                    }
                    let scrollOffsetY = scrollView.safeAreaInsets.top + contentOffset.y
                    let relativeViewFrame = view.convert(view.frame, to: scrollView)
                    let viewPositionY = relativeViewFrame.maxY - scrollOffsetY
                    self.offset = viewPositionY
                }
        }

    }

    @StateObject private var model = ViewModel()
    @Binding private var isVisible: Bool
    private let threshold: CGFloat

    init(isVisible: Binding<Bool>, threshold: CGFloat) {
        _isVisible = isVisible
        self.threshold = threshold
    }

    func body(content: Content) -> some View {
        content
            .hookView { view in
                print("hookView")
                model.subscribe(to: view)
            }
            .onChange(of: model.offset) { offset in
                let isVisible = offset > threshold
                guard self.isVisible != isVisible else {
                    return
                }
                withAnimation {
                    self.isVisible = isVisible
                }
            }
    }

}

extension View {

    public func isVisibleInScrollView(_ isVisible: Binding<Bool>, threshold: CGFloat = 0.0) -> some View {
        return modifier(IsVisibleInScrollView(isVisible: isVisible, threshold: threshold))
    }

}

#endif
