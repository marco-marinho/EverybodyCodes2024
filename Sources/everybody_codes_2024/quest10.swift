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

    private static func getWordIncomplete(
        grid: inout [[Character]], row_offset: Int, col_offset: Int
    )
        -> (Int, Bool)
    {
        var word = [Character]()
        var missing = [(Int, Int)]()
        for row in (row_offset + 2)..<(row_offset + 6) {
            for col in (col_offset + 2)..<(col_offset + 6) {
                if grid[row][col] != "." {
                    continue
                }
                let row_set = Set(grid[row][col_offset..<(col_offset + 8)])
                let col_set = Set(grid.map { $0[col] }[row_offset..<(row_offset + 8)])
                let intersection = row_set.intersection(col_set).filter { $0 != "." && $0 != "*" }
                if let rune = intersection.first {
                    grid[row][col] = rune
                } else {
                    missing.append((row, col))
                }
            }
        }
        var foundNew = false
        for (row, col) in missing {
            let used_row = Set(grid[row][col_offset + 2..<(col_offset + 6)])
            let given_row = Set(
                grid[row][col_offset..<(col_offset + 2)]
                    + grid[row][(col_offset + 6)..<(col_offset + 8)]
            )
            let used_col = Set(grid.map { $0[col] }[row_offset + 2..<(row_offset + 6)])
            let given_col = Set(
                grid.map { $0[col] }[row_offset..<(row_offset + 2)]
                    + grid.map { $0[col] }[(row_offset + 6)..<(row_offset + 8)]
            )
            let remaining = given_row.subtracting(used_row)
                .union(given_col.subtracting(used_col)).subtracting(Set(["?"]))
            if remaining.count == 1 {
                grid[row][col] = remaining.first!
                for r in row_offset..<(row_offset + 8) {
                    if grid[r][col] == "?" {
                        grid[r][col] = remaining.first!
                    }
                }
                for c in col_offset..<(col_offset + 8) {
                    if grid[row][c] == "?" {
                        grid[row][c] = remaining.first!
                    }
                }
                foundNew = true
            }
        }
        for row in (row_offset + 2)..<(row_offset + 6) {
            for col in (col_offset + 2)..<(col_offset + 6) {
                word.append(grid[row][col])
            }
        }
        if word.filter({ $0 == "." }).count > 0 {
            return (0, foundNew)
        }
        return (wordPower(word: word), foundNew)
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
        var grid = readInputLines(quest: 10, part: 3).map { Array($0) }
        var progress = true
        while progress {
            progress = false
            var totalPower = 0
            for row_offset in stride(from: 0, to: grid.count - 2, by: 6) {
                for col_offset in stride(from: 0, to: grid[0].count - 2, by: 6) {
                    let (power, foundNew) = getWordIncomplete(
                        grid: &grid, row_offset: row_offset, col_offset: col_offset)
                    totalPower += power
                    progress = progress || foundNew
                }
            }
            if !progress {
                print(totalPower)
            }
        }
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
