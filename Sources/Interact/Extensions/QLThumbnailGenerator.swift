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
import QuickLookThumbnailing

extension QLThumbnailGenerator {

    public func thumbnailRepresentation(fileAt url: URL,
                                        size: CGSize,
                                        scale: CGFloat,
                                        iconMode: Bool) async throws -> QLThumbnailRepresentation {
        let request = Request(fileAt: url, size: size, scale: scale, representationTypes: .thumbnail)
        request.iconMode = iconMode
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                generateRepresentations(for: request) { (thumbnail, type, error) in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: thumbnail!)
                }
            }
        } onCancel: {
            cancel(request)
        }
    }

}
