import Foundation

enum Quest10 {

    private static func wordPower(word: [Character]) -> Int {
        var power = 0
        for (idx, char) in word.enumerated() {
            let charValue = Int(char.asciiValue! - Character("A").asciiValue! + 1)
            power += charValue * (idx + 1)
        }
        return power
    }

    private static func getWord(grid: [[Character]], row_offset: Int, col_offset: Int)
        -> [Character]
    {
        var word = [Character]()
        for row in (row_offset + 2)..<(row_offset + 6) {
            for col in (col_offset + 2)..<(col_offset + 6) {
                let row_set = Set(grid[row][col_offset..<(col_offset + 8)])
                let col_set = Set(grid.map { $0[col] }[row_offset..<(row_offset + 8)])
                let intersection = row_set.intersection(col_set).filter { $0 != "." && $0 != "*" }
                word.append(intersection.first!)
            }
        }
        return word
    }

    private static func part1() {
        let grid = readInputLines(quest: 10, part: 1).map { Array($0) }
        let word = getWord(grid: grid, row_offset: 0, col_offset: 0)
        print(String(word))
    }

    private static func part2() {
        let grid = readInputLines(quest: 10, part: 2).map { Array($0) }
        var totalPower = 0
        for row_offset in stride(from: 0, to: grid.count, by: 9) {
            for col_offset in stride(from: 0, to: grid[0].count, by: 9) {
                let word = getWord(grid: grid, row_offset: row_offset, col_offset: col_offset)
                let power = wordPower(word: word)
                totalPower += power
            }
        }
        print(totalPower)
    }

    private static func part3() {
    }

    static func solve(part: Int) {
        switch part {
        case 1: part1()
        case 2: part2()
        case 3: part3()
        default: print("Part \(part) not implemented yet.")
        }
    }
}
