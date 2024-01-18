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

import SwiftUI

public struct RoundedCorner: Shape {

    public let radius: CGFloat
    public let corners: RectCorner

    public init(radius: CGFloat, corners: RectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {

        let topLeftRadius: CGFloat = corners.contains(.topLeft) ? radius : 0
        let bottomLeftRadius: CGFloat = corners.contains(.bottomLeft) ? radius : 0
        let bottomRightRadius: CGFloat = corners.contains(.bottomRight) ? radius : 0
        let topRightRadius: CGFloat = corners.contains(.topRight) ? radius : 0

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: topLeftRadius))
        path.addLine(to: CGPoint(x: 0, y: rect.height - bottomLeftRadius))
        path.addArc(center: CGPoint(x: bottomLeftRadius, y: rect.height - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: CGFloat.pi,
                    endAngle: (CGFloat.pi / 2),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width - bottomRightRadius, y: rect.height))
        path.addArc(center: CGPoint(x: rect.width - bottomRightRadius, y: rect.height - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: (CGFloat.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width, y: topRightRadius))
        path.addArc(center: CGPoint(x: rect.width - topRightRadius, y: topRightRadius),
                    radius: topRightRadius,
                    startAngle: 0,
                    endAngle: (CGFloat.pi / 2) * 3,
                    clockwise: true)
        path.addLine(to: CGPoint(x: topLeftRadius, y: 0))
        path.addArc(center: CGPoint(x: topLeftRadius, y: topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: (CGFloat.pi / 2) * 3,
                    endAngle: CGFloat.pi,
                    clockwise: true)
        path.closeSubpath()
        return Path(path)
    }
}
