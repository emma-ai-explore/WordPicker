import Foundation
import SQLite

class DictService {
    static let shared = DictService()

    private var db: Connection?
    private let words = Table("words")
    private let word = Expression<String>("word")
    private let phonetic = Expression<String?>("phonetic")
    private let translation = Expression<String?>("translation")

    private init() {
        openDatabase()
    }

    private func openDatabase() {
        guard let dbPath = Bundle.main.path(forResource: "dict", ofType: "db") else {
            print("Dictionary database not found")
            return
        }

        do {
            db = try Connection(dbPath)
        } catch {
            print("Failed to open database: \(error)")
        }
    }

    func lookup(word: String) -> WordEntry? {
        let normalizedWord = word.lowercased().trimmingCharacters(in: .whitespaces)

        do {
            let query = words.filter(self.word == normalizedWord)
            if let row = try db?.pluck(query) {
                return WordEntry(
                    word: row[self.word],
                    phonetic: row[phonetic],
                    translation: row[translation]
                )
            }
        } catch {
            print("Lookup failed: \(error)")
        }

        return nil
    }
}