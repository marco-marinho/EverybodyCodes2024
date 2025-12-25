import Collections
import Foundation

enum Quest18 {

    private static func floodFill(grid: borrowing [[Character]], start: [(Int, Int)]) -> [[Int]] {
        var timeGrid = [[Int]](
            repeating: [Int](repeating: Int.max, count: grid[0].count), count: grid.count)
        var queue = Deque<((Int, Int), Int)>()
        var visited = Set<IntPair>()
        for element in start {
            queue.append((element, 0))
        }

        while !queue.isEmpty {
            let (pos, time) = queue.removeFirst()
            if visited.contains(IntPair(x: pos.0, y: pos.1)) {
                continue
            }
            timeGrid[pos.0][pos.1] = time
            visited.insert(IntPair(x: pos.0, y: pos.1))
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            for dir in directions {
                let newRow = pos.0 + dir.0
                let newCol = pos.1 + dir.1
                if newRow < 0 || newRow >= grid.count || newCol < 0 || newCol >= grid[0].count {
                    continue
                }
                if grid[newRow][newCol] == "#" {
                    continue
                }
                if visited.contains(IntPair(x: newRow, y: newCol)) {
                    continue
                }
                queue.append(((newRow, newCol), time + 1))
            }
        }
        return timeGrid
    }

    private static func part1() {
        let grid = readInputLines(quest: 18, part: 1).map { Array($0) }
        let startRow = grid.map { $0[0] }.firstIndex(of: ".")!
        let palms = findOccurences(grid: grid, target: "P")
        let timeGrid = floodFill(grid: grid, start: [(startRow, 0)])
        let time = palms.map { timeGrid[$0.0][$0.1] }.max()!
        print(time)
    }

    private static func part2() {
        let grid = readInputLines(quest: 18, part: 2).map { Array($0) }
        let startLeft = grid.map { $0[0] }.firstIndex(of: ".")!
        let startRight = grid.map { $0[grid[0].count - 1] }.firstIndex(of: ".")!
        let palms = findOccurences(grid: grid, target: "P")
        let timeGrid = floodFill(
            grid: grid, start: [(startLeft, 0), (startRight, grid[0].count - 1)])
        let time = palms.map { timeGrid[$0.0][$0.1] }.max()!
        print(time)
    }

    private static func part3() {
        let grid = readInputLines(quest: 18, part: 3).map { Array($0) }
        let possibleStarts = findOccurences(grid: grid, target: ".")
        let palms = findOccurences(grid: grid, target: "P")
        var minSum = Int.max
        for start in possibleStarts {
            let timeGrid = floodFill(
                grid: grid, start: [start])
            let time = palms.map { timeGrid[$0.0][$0.1] }.reduce(0, +)
            minSum = min(minSum, time)
        }
        print(minSum)
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
