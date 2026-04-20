import Foundation

struct WordEntry: Codable, Identifiable {
    var id: String { word }
    let word: String
    let phonetic: String?
    let translation: String?

    var formattedPhonetic: String {
        phonetic.map { "[\($0)]" } ?? ""
    }

    var translationLines: [String] {
        translation?.components(separatedBy: "\\n") ?? []
    }
}