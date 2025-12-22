import Collections

enum Quest13 {

    private struct Node: Comparable {
        let position: IntPair
        let cost: Int

        static func < (lhs: Node, rhs: Node) -> Bool {
            return lhs.cost < rhs.cost
        }

        static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.position == rhs.position && lhs.cost == rhs.cost
        }

        var pair: IntPair { IntPair(x: position.x, y: position.y) }
    }

    private static func cellHeight(cell: Character) -> Int {
        switch cell {
        case "S": return 0
        case "E": return 0
        case let c where c.isNumber:
            return Int(c.asciiValue! - Character("0").asciiValue!)
        default:
            fatalError("Unknown cell type \(cell)")
        }

    }

    private static func cellCost(from: Character, to: Character) -> Int {
        let fromHeight = cellHeight(cell: from)
        let toHeight = cellHeight(cell: to)
        return min(
            abs(toHeight - fromHeight), (toHeight - fromHeight + 10) % 10,
            (fromHeight - toHeight + 10) % 10)
    }

    private static func djikstra(grid: [[Character]], start: (Int, Int), end: Character) -> Int {
        var queue = Heap<Node>()
        queue.insert(Node(position: IntPair(x: start.0, y: start.1), cost: 0))
        var visited = Set<IntPair>()
        while !queue.isEmpty {
            let current = queue.popMin()!
            let (x, y) = (current.position.x, current.position.y)
            let currentCell = grid[x][y]
            if currentCell == end {
                return current.cost
            }
            if visited.contains(current.pair) {
                continue
            }
            visited.insert(current.pair)
            let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
            for (dx, dy) in directions {
                let newX = x + dx
                let newY = y + dy
                if newX < 0 || newX >= grid.count || newY < 0 || newY >= grid[0].count {
                    continue
                }
                let nextCell = grid[newX][newY]
                let nextPair = IntPair(x: newX, y: newY)
                if nextCell == "#" || visited.contains(nextPair) {
                    continue
                }
                let moveCost = cellCost(from: currentCell, to: nextCell) + 1
                let newNode = Node(
                    position: nextPair, cost: current.cost + moveCost)
                queue.insert(newNode)
            }
        }
        return Int.max
    }

    private static func findElement(element: Character, in grid: [[Character]]) -> (Int, Int)? {
        for (i, row) in grid.enumerated() {
            for (j, cell) in row.enumerated() {
                if cell == element {
                    return (i, j)
                }
            }
        }
        return nil
    }

    private static func part1() {
        let grid = readInputLines(quest: 13, part: 1).map { Array($0) }
        let start = findElement(element: "S", in: grid)!
        print(djikstra(grid: grid, start: start, end: "E"))
    }

    private static func part2() {
        let grid = readInputLines(quest: 13, part: 2).map { Array($0) }
        let start = findElement(element: "S", in: grid)!
        print(djikstra(grid: grid, start: start, end: "E"))
    }

    private static func part3() {
        let grid = readInputLines(quest: 13, part: 3).map { Array($0) }
        let start = findElement(element: "E", in: grid)!
        print(djikstra(grid: grid, start: start, end: "S"))
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
