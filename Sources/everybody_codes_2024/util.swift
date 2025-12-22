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

struct IntPair: Hashable {
    let x: Int
    let y: Int
}

func uniquePermutations<T: Hashable>(_ elements: [T: Int]) -> [[T]] {
    var result: [[T]] = []
    var current: [T] = []
    var counts = elements

    func backtrack() {
        if current.count == elements.values.reduce(0, +) {
            result.append(current)
            return
        }

        for element in counts.keys {
            if counts[element]! > 0 {
                current.append(element)
                counts[element]! -= 1

                backtrack()

                counts[element]! += 1
                current.removeLast()
            }
        }
    }

    backtrack()
    return result
}
