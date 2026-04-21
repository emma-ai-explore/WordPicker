import AppKit
import Carbon

class SelectionMonitor {
    static let shared = SelectionMonitor()

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let debouncer = Debouncer(delay: Constants.selectionDebounceInterval)

    var onTextSelected: ((String, CGPoint) -> Void)?
    var isEnabled = true

    private init() {}

    func start() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) |
                        (1 << CGEventType.keyUp.rawValue) |
                        (1 << CGEventType.leftMouseUp.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon in
                return Unmanaged.passRetained(event)
            },
            userInfo: nil
        ) else {
            print("Failed to create event tap")
            return
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(nil, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        // 监听选择变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkSelection),
            name: NSNotification.Name("NSAccessibilityAnnouncementRequestedNotification"),
            object: nil
        )
    }

    @objc private func checkSelection() {
        guard isEnabled else { return }

        debouncer.debounce { [weak self] in
            self?.fetchSelectedText()
        }
    }

    private func fetchSelectedText() {
        // 模拟 Cmd+C 获取选中文本
        let pasteboard = NSPasteboard.general
        let oldContent = pasteboard.string(forType: .string)
        pasteboard.clearContents()

        // 发送 Cmd+C
        let source = CGEventSource(stateID: .combinedSessionState)
        let cDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_C), keyDown: true)
        let cUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_C), keyDown: false)

        cDown?.flags = .maskCommand
        cUp?.flags = .maskCommand

        cDown?.post(tap: .cghidEventTap)
        cUp?.post(tap: .cghidEventTap)

        // 等待剪贴板更新
        usleep(100000)

        let selectedText = pasteboard.string(forType: .string) ?? ""

        // 恢复原剪贴板内容
        if let old = oldContent {
            pasteboard.clearContents()
            pasteboard.setString(old, forType: .string)
        }

        processSelectedText(selectedText)
    }

    private func processSelectedText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isEnglishWord(trimmed) else { return }

        let mouseLocation = NSEvent.mouseLocation

        if let entry = DictService.shared.lookup(word: trimmed) {
            DispatchQueue.main.async {
                self.onTextSelected?(trimmed, mouseLocation)
                FloatWindowController.shared.show(entry: entry, at: mouseLocation)
            }
        }
    }

    private func isEnglishWord(_ text: String) -> Bool {
        let pattern = "^[a-zA-Z]+$"
        return text.range(of: pattern, options: .regularExpression) != nil && text.count >= 2
    }

    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
    }
}
