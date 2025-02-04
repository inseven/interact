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

#if canImport(ServiceManagement)
import ServiceManagement
#endif

public class Application: ObservableObject {

    public static func open(_ url: URL) {
#if os(macOS)
        NSWorkspace.shared.open(url)
#else
        UIApplication.shared.open(url)
#endif
    }

    public static func registerForRemoteNotifications() {
#if os(macOS)
        NSApplication.shared.registerForRemoteNotifications()
#else
        UIApplication.shared.registerForRemoteNotifications()
#endif
    }

    public static func reveal(_ url: URL) {
#if os(macOS)
        NSWorkspace.shared.activateFileViewerSelecting([url])
#else
        assertionFailure("Unsupported")
#endif
    }

    public static func setBadgeNumber(_ badgeNumber: Int) {
#if os(macOS)
        if badgeNumber == 0 {
            NSApplication.shared.dockTile.badgeLabel = nil
        } else {
            NSApplication.shared.dockTile.badgeLabel = String(describing: badgeNumber)
        }
#else
        UIApplication.shared.applicationIconBadgeNumber = badgeNumber
#endif
    }

    public static func setClipboard(_ value: String) {
#if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(value, forType: .string)
#else
        UIPasteboard.general.string = value
#endif
    }

    public static var shared = Application()

#if canImport(ServiceManagement)

    @available(macOS 13.0, *)
    @available(macCatalyst 16.0, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @MainActor public var openAtLogin: Bool {
        get {
            return SMAppService.mainApp.status == .enabled
        }
        set {
            objectWillChange.send()
            do {
                if newValue {
                    if SMAppService.mainApp.status == .enabled {
                        try? SMAppService.mainApp.unregister()
                    }
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update service with error \(error).")
            }
        }
    }

#endif

}
