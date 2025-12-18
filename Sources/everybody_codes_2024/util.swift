import Foundation

func readInput(quest: Int, part: Int) -> String {
    let paddedQuest = String(format: "%02d", quest)
    let currentDirectory = FileManager.default.currentDirectoryPath
    let filePath = currentDirectory + "/data/quest\(paddedQuest)_\(part).txt"
    
    guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
        fatalError("\n Could not read file at: \(filePath)\n")
    }
    
    return content.trimmingCharacters(in: .newlines)
}

func readInputLines(quest: Int, part: Int) -> [String] {
    let input = readInput(quest: quest, part: part)
    return input.components(separatedBy: .newlines)
}

extension Array {
    // Return an array of Slices (Views), not Arrays (Copies)
    func chunked(into size: Int) -> [ArraySlice<Element>] {
        return stride(from: 0, to: count, by: size).map {
            // Just return the slice directly. No allocation of element data.
            self[$0..<Swift.min($0 + size, count)]
        }
    }
}