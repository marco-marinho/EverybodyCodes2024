import Collections

enum Quest15 {

    private struct CacheKey: Hashable {
        let x_start: Int
        let y_start: Int
        let x_end: Int
        let y_end: Int
    }

    private struct MemoKey: Hashable {
        let x: Int
        let y: Int
        let available: [Character]
    }

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
        var queue = Deque<Node>()
        queue.append(Node(position: IntPair(x: start.0, y: start.1), cost: 0))
        var visited = Set<IntPair>()
        while !queue.isEmpty {
            let current = queue.popFirst()!
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
                queue.append(newNode)
            }
        }
        return Int.max
    }

    private static func dfs(
        costs: borrowing [CacheKey: Int], locations: borrowing [Character: [(Int, Int)]],
        current: (Character, (Int, Int)), available: [Character],
        memo: inout [MemoKey: Int]
    ) -> Int {
        let (currentChar, currentPos) = current
        if let cached = memo[
            MemoKey(x: currentPos.0, y: currentPos.1, available: available)]
        {
            return cached
        }
        if available.isEmpty && currentChar == "S" {
            return 0
        }
        var minCost = Int.max
        for next in available.isEmpty ? ["S"] : available {
            let possiblePoisitions = locations[next]!
            let nextAvailable = available.filter { $0 != next }.sorted()
            for position in possiblePoisitions {
                let possibleCost = costs[
                    CacheKey(
                        x_start: currentPos.0, y_start: currentPos.1,
                        x_end: position.0, y_end: position.1)]!
                let newCost =
                    possibleCost
                    + dfs(
                        costs: costs, locations: locations,
                        current: (next, position),
                        available: nextAvailable,
                        memo: &memo)
                minCost = min(minCost, newCost)
            }
        }
        memo[MemoKey(x: currentPos.0, y: currentPos.1, available: available)] =
            minCost
        return minCost
    }

    private static func part1() {
        let grid = readInputLines(quest: 15, part: 1).map { Array($0) }
        let start = (0, grid[0].firstIndex(of: ".")!)
        let targets = findOccurences(grid: grid, target: "H")
        let costs = targets.map { djikstra(grid: grid, start: start, end: $0) }
        print(costs.min()! * 2)
    }

    private static func part2() {
        let grid = readInputLines(quest: 15, part: 2).map { Array($0) }
        var locations = [Character: [(Int, Int)]]()
        locations["S"] = [(0, Int(grid[0].firstIndex(of: ".")!))]
        locations["A"] = findOccurences(grid: grid, target: "A")
        locations["B"] = findOccurences(grid: grid, target: "B")
        locations["C"] = findOccurences(grid: grid, target: "C")
        locations["D"] = findOccurences(grid: grid, target: "D")
        locations["E"] = findOccurences(grid: grid, target: "E")
        var costs = [CacheKey: Int]()

        for combination in locations.keys.combinations(ofCount: 2) {
            for entry in locations[combination[0]]! {
                for exit in locations[combination[1]]! {
                    let cost = djikstra(grid: grid, start: entry, end: exit)
                    let key = CacheKey(
                        x_start: entry.0, y_start: entry.1,
                        x_end: exit.0, y_end: exit.1)
                    let keyInverted = CacheKey(
                        x_start: exit.0, y_start: exit.1,
                        x_end: entry.0, y_end: entry.1)
                    costs[key] = cost
                    costs[keyInverted] = cost
                }
            }
        }
        var memo = [MemoKey: Int]()
        print(
            dfs(
                costs: costs, locations: locations, current: ("S", locations["S"]![0]),
                available: ["A", "B", "C", "D", "E"], memo: &memo))
    }

    private static func part3() {
        let grid = readInputLines(quest: 15, part: 3).map { Array($0) }
        var locations = [Character: [(Int, Int)]]()
        locations["S"] = [(0, Int(grid[0].firstIndex(of: ".")!))]
        let herbs: [Character] = [
            "A", "B", "C", "D", "E", "G", "H", "I", "J", "K", "N", "O", "P", "Q",
            "R",
        ]
        for herb in herbs {
            let found = findOccurences(grid: grid, target: herb)
            if found.isEmpty {
                fatalError("Herb \(herb) not found in the grid")
            }
            locations[herb] = found
        }
        var costs = [CacheKey: Int]()

        for combination in locations.keys.combinations(ofCount: 2) {
            for entry in locations[combination[0]]! {
                for exit in locations[combination[1]]! {
                    let cost = djikstra(grid: grid, start: entry, end: exit)
                    let key = CacheKey(
                        x_start: entry.0, y_start: entry.1,
                        x_end: exit.0, y_end: exit.1)
                    let keyInverted = CacheKey(
                        x_start: exit.0, y_start: exit.1,
                        x_end: entry.0, y_end: entry.1)
                    costs[key] = cost
                    costs[keyInverted] = cost
                }
            }
        }
        var memo = [MemoKey: Int]()
        print(
            dfs(
                costs: costs, locations: locations, current: ("S", locations["S"]![0]),
                available: herbs, memo: &memo))
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
