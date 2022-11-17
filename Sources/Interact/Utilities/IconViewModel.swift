// Copyright (c) 2018-2022 InSeven Limited
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
import QuickLookThumbnailing

class IconViewModel: ObservableObject, Runnable {

    private let url: URL
    private let size: CGSize
    @MainActor @Published public var scale: CGFloat = 2.0

    @MainActor private var request: QLThumbnailGenerator.Request?
    @MainActor private var requestedScale: CGFloat = 0.0
    @MainActor private var cancelables: Set<AnyCancellable> = []

    @Published var image: Image?

    init(url: URL, size: CGSize) {
        self.url = url
        self.size = size
    }

    @MainActor func start() {
        $scale
            .receive(on: DispatchQueue.main)
            .sink { scale in
                self.request(scale: scale)
            }
            .store(in: &cancelables)
    }

    @MainActor func stop() {
        cancelables.removeAll()
        cancelRequest()
    }

    @MainActor func request(scale: CGFloat) {
        guard requestedScale != scale else {
            return
        }
        cancelRequest()
        requestedScale = scale
        let request = QLThumbnailGenerator.Request(fileAt: url,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .thumbnail)
        request.iconMode = true
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { [weak self] (thumbnail, type, error) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                guard let thumbnail = thumbnail else {
                    return
                }
                self.image = Image(thumbnail.cgImage,
                                   scale: self.scale,
                                   label: Text("Icon thumbnail for '\(self.url.displayName)'"))
            }
        }
        self.request = request
    }

    @MainActor private func cancelRequest() {
        guard let request = request else {
            return
        }
        QLThumbnailGenerator.shared.cancel(request)
        self.request = nil
        requestedScale = 0.0
    }

}