import SwiftUI

struct FloatWindowView: View {
    let entry: WordEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.word)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                if !entry.formattedPhonetic.isEmpty {
                    Text(entry.formattedPhonetic)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            ForEach(entry.translationLines, id: \.self) { line in
                Text(line)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Constants.floatWindowPadding)
        .frame(width: Constants.floatWindowWidth)
        .background(Color(nsColor: .windowBackgroundColor))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}