import AppKit
import SwiftUI

class FloatWindowController: NSWindowController {
    static let shared = FloatWindowController()

    private var hostingView: NSHostingView<FloatWindowView>?
    private var currentEntry: WordEntry?

    private init() {
        let panel = NSPanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.hidesOnDeactivate = false

        super.init(window: panel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(entry: WordEntry, at point: CGPoint) {
        currentEntry = entry

        let view = FloatWindowView(entry: entry)
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = NSRect(x: 0, y: 0, width: Constants.floatWindowWidth + Constants.floatWindowPadding * 2, height: 100)

        window?.contentView = hostingView
        window?.setContentSize(hostingView.fittingSize)

        let screenFrame = NSScreen.main?.frame ?? .zero
        var windowX = point.x + 10
        var windowY = screenFrame.height - point.y - window!.frame.height - 20

        // 确保窗口不超出屏幕边界
        windowX = max(0, min(windowX, screenFrame.width - window!.frame.width))
        windowY = max(0, min(windowY, screenFrame.height - window!.frame.height))

        window?.setFrameOrigin(NSPoint(x: windowX, y: windowY))
        window?.makeKeyAndOrderFront(nil)
    }

    func hide() {
        window?.orderOut(nil)
        currentEntry = nil
    }

    func isVisible: Bool {
        return window?.isVisible ?? false
    }
}
