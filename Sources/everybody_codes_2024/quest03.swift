enum Quest03 {

    private static func dig(
        targets: [(x: Int, y: Int)], rows: Int, cols: Int, diagonals: Bool = false
    ) -> Int {
        let directions =
            diagonals
            ? [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
            : [(-1, 0), (1, 0), (0, -1), (0, 1)]
        var depth = [[Int]](repeating: [Int](repeating: 0, count: cols), count: rows)
        var digged = true
        while digged {
            digged = false
            var toDig = [(x: Int, y: Int)]()
            for (row, col) in targets {
                let differences = directions.map { (dx, dy) -> Int in
                    depth[row][col] - depth[row + dx][col + dy]
                }
                if !differences.allSatisfy({ $0 == 0 }) { continue }
                toDig.append((x: row, y: col))
            }
            for (row, col) in toDig {
                depth[row][col] += 1
                digged = true
            }
        }
        return depth.map { $0.reduce(0, +) }.reduce(0, +)
    }

    private static func parseGrid(input: [String]) -> ([(x: Int, y: Int)], Int, Int) {
        let grid = input.map { Array($0) }
        var toCheck = [(x: Int, y: Int)]()
        for row in 0..<grid.count {
            for col in 0..<grid[0].count {
                if grid[row][col] == "#" {
                    toCheck.append((x: row, y: col))
                }
            }
        }
        return (toCheck, grid.count, grid[0].count)
    }

    private static func part1() {
        let input = readInputLines(quest: 3, part: 1)
        let (toCheck, rows, cols) = parseGrid(input: input)
        let result = dig(targets: toCheck, rows: rows, cols: cols)
        print(result)
    }

    private static func part2() {
        let input = readInputLines(quest: 3, part: 2)
        let (toCheck, rows, cols) = parseGrid(input: input)
        let result = dig(targets: toCheck, rows: rows, cols: cols)
        print(result)
    }

    private static func part3() {
        let input = readInputLines(quest: 3, part: 3)
        let (toCheck, rows, cols) = parseGrid(input: input)
        let toCheckOffset = toCheck.map { ($0.x + 1, $0.y + 1) }
        let result = dig(targets: toCheckOffset, rows: rows + 2, cols: cols + 2, diagonals: true)
        print(result)
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
