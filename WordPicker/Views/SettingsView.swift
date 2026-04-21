import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("isEnabled") var isEnabled = true
    @AppStorage("launchAtLogin") var launchAtLogin = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("WordPicker 设置")
                .font(.title2)
                .fontWeight(.bold)

            Divider()

            Toggle("启用划词翻译", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    SelectionMonitor.shared.isEnabled = newValue
                }

            Toggle("开机自启动", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    setLaunchAtLogin(newValue)
                }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("快捷键")
                    .font(.headline)
                Text("Cmd+Shift+T: 开关翻译")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 300, height: 250)
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        let launcherIdentifier = "com.wordpicker.launcher"

        if enabled {
            SMLoginItemSetEnabled(launcherIdentifier as CFString, true)
        } else {
            SMLoginItemSetEnabled(launcherIdentifier as CFString, false)
        }
    }
}
