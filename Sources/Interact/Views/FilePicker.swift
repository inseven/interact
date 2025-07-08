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

@available(macOS 13.0, *)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct FilePickerOptions: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let canChooseFiles = Self(rawValue: 1 << 0)
    public static let canChooseDirectories = Self(rawValue: 1 << 1)
    public static let canCreateDirectories = Self(rawValue: 1 << 2)
}

@available(macOS 13.0, *)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct FilePicker<Label: View>: View {

    let label: Label
    let options: FilePickerOptions

    @Binding var url: URL

    public init(url: Binding<URL>, options: FilePickerOptions = [], @ViewBuilder label: () -> Label) {
        self.label = label()
        self.options = options
        _url = url
    }

    public var body: some View {
        LabeledContent {
            HStack {
                Text(url.displayName)
                Button("Select...") {
                    let openPanel = NSOpenPanel()
                    openPanel.canChooseFiles = options.contains(.canChooseFiles)
                    openPanel.canChooseDirectories = options.contains(.canChooseDirectories)
                    openPanel.canCreateDirectories = options.contains(.canCreateDirectories)
                    openPanel.directoryURL = url.hasDirectoryPath ? url : url.deletingLastPathComponent()
                    guard
                        openPanel.runModal() ==  NSApplication.ModalResponse.OK,
                        let url = openPanel.url
                    else {
                        return
                    }
                    self.url = url
                }
            }
        } label: {
            label
        }
    }

}

@available(macOS 13.0, *)
@available(macCatalyst, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension FilePicker where Label == Text {

    public init(_ titleKey: LocalizedStringKey, url: Binding<URL>, options: FilePickerOptions = []) {
        self.label = Text(titleKey)
        self.options = options
        _url = url
    }

}

#endif
