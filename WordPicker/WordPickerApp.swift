import SwiftUI

@main
struct WordPickerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    @AppStorage("isEnabled") var isEnabled = true

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        SelectionMonitor.shared.start()

        SelectionMonitor.shared.onTextSelected = { word, point in
            print("Selected: \(word) at \(point)")
        }
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "character.book.closed", accessibilityDescription: "WordPicker")
        }

        let menu = NSMenu()

        let toggleItem = NSMenuItem(
            title: "启用翻译",
            action: #selector(toggleEnabled),
            keyEquivalent: "t"
        )
        toggleItem.keyEquivalentModifierMask = [.command, .shift]
        toggleItem.state = isEnabled ? .on : .off
        menu.addItem(toggleItem)

        menu.addItem(NSMenuItem(title: "设置", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc private func toggleEnabled() {
        isEnabled.toggle()
        SelectionMonitor.shared.isEnabled = isEnabled

        if let menu = statusItem?.menu?.items.first {
            menu.state = isEnabled ? .on : .off
        }
    }

    @objc private func openSettings() {
        NSApp.sendAction(Selector("showSettingsWindow:"), to: nil, from: nil)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
