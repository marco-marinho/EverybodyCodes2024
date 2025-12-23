import Collections

enum Quest15 {

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

    private static func djikstra(grid: borrowing [[Character]], start: (Int, Int), end: (Int, Int))
        -> Int
    {
        var queue = Heap<Node>()
        queue.insert(Node(position: IntPair(x: start.0, y: start.1), cost: 0))
        var visited = Set<IntPair>()
        while !queue.isEmpty {
            let current = queue.popMin()!
            let (x, y) = (current.position.x, current.position.y)
            if (x, y) == end {
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
                if nextCell == "#" || nextCell == "~" || visited.contains(nextPair) {
                    continue
                }
                let newNode = Node(
                    position: nextPair, cost: current.cost + 1)
                queue.insert(newNode)
            }
        }
        return Int.max
    }

    private static func part1() {
        let grid = readInputLines(quest: 15, part: 1).map { Array($0) }
        let start = (0, grid[0].firstIndex(of: ".")!)
        var targets = [(Int, Int)]()
        for (i, row) in grid.enumerated() {
            for (j, cell) in row.enumerated() {
                if cell == "H" {
                    targets.append((i, j))
                }
            }
        }
        let costs = targets.map { djikstra(grid: grid, start: start, end: $0) }
        print(costs.min()! * 2)
    }

    private static func part2() {
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
