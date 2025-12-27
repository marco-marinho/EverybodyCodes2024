import Collections

enum Quest20 {

    private struct State: Hashable {
        let x: Int
        let y: Int
        let direction: Direction
    }

    private struct State2: Hashable {
        let x: Int
        let y: Int
        let direction: Direction
        let visited: Visited
    }

    enum Direction: Hashable {
        case up
        case right
        case down
        case left
    }

    enum Visited: Hashable {
        case None
        case A
        case B
        case C
    }

    @inline(__always)
    private static func validSteps(directions: Direction) -> [(Int, Int, Direction)] {
        switch directions {
        case .up:
            return [(0, -1, .left), (-1, 0, .up), (0, 1, .right)]
        case .down:
            return [(0, -1, .left), (+1, 0, .down), (0, 1, .right)]
        case .left:
            return [(0, -1, .left), (+1, 0, .down), (-1, 0, .up)]
        case .right:
            return [(0, 1, .right), (+1, 0, .down), (-1, 0, .up)]
        }
    }

    @inline(__always)
    private static func getAltitudeDifferential(grid: borrowing [[Character]], at: (Int, Int))
        -> Int
    {
        switch grid[at.0][at.1] {
        case ".": return -1
        case "-": return -2
        case "+": return 1
        case "A": return -1
        case "B": return -1
        case "C": return -1
        default: fatalError("Invalid cell character")
        }
    }

    @inline(__always)
    private static func getNextVisited(
        grid: borrowing [[Character]], at: (Int, Int), current: Visited
    )
        -> Visited
    {
        if grid[at.0][at.1] == "A" && current == .None {
            return .A
        } else if grid[at.0][at.1] == "B" && current == .A {
            return .B
        } else if grid[at.0][at.1] == "C" && current == .B {
            return .C
        } else {
            return current
        }
    }

    private static func bfs(grid: borrowing [[Character]], start: (Int, Int)) -> Int {
        var visitedBest = [State: Int]()
        var queue = Deque<(State, Int, Int)>()
        let initial_states = [
            State(x: start.0, y: start.1, direction: Direction.down),
            State(x: start.0, y: start.1, direction: Direction.right),
            State(x: start.0, y: start.1, direction: Direction.left),
        ]
        for state in initial_states {
            queue.append((state, 1000, 0))
            visitedBest[state] = 1000
        }
        while !queue.isEmpty {
            var nextQueue = Deque<(State, Int, Int)>()
            while !queue.isEmpty {
                let (currentState, altitude, steps) = queue.removeFirst()
                if steps == 100 {
                    continue
                }
                let nextSteps = validSteps(directions: currentState.direction)
                for (dx, dy, newDirection) in nextSteps {
                    let newX = currentState.x + dx
                    let newY = currentState.y + dy
                    if newX < 0 || newX >= grid.count || newY < 0 || newY >= grid[0].count {
                        continue
                    }
                    if grid[newX][newY] == "#" || grid[newX][newY] == "S" {
                        continue
                    }
                    let altitudeDiff = getAltitudeDifferential(grid: grid, at: (newX, newY))
                    let nextState = State(
                        x: newX, y: newY, direction: newDirection)
                    let nextAltitude = altitude + altitudeDiff
                    if visitedBest[nextState, default: 0] >= nextAltitude {
                        continue
                    }
                    visitedBest[nextState] = nextAltitude
                    nextQueue.append((nextState, nextAltitude, steps + 1))
                }
            }
            queue = nextQueue
        }
        return visitedBest.values.max()!
    }

    private static func bfs2(grid: borrowing [[Character]], start: (Int, Int)) -> Int {
        var visitedBest = [State2: Int]()
        var queue = [State2: Int]()
        let initial_states = [
            State2(x: start.0, y: start.1, direction: Direction.down, visited: .None)
        ]
        for state in initial_states {
            queue[state] = 10000
            visitedBest[state] = 10000
        }
        var steps = 0
        while !queue.isEmpty {
            var nextQueue = [State2: Int]()
            for (currentState, altitude) in queue {
                if altitude < 9900 || altitude > 10100 {
                    continue
                }
                let nextSteps = validSteps(directions: currentState.direction)
                for (dx, dy, newDirection) in nextSteps {
                    let newX = currentState.x + dx
                    let newY = currentState.y + dy
                    if newX < 0 || newX >= grid.count || newY < 0 || newY >= grid[0].count {
                        continue
                    }
                    if grid[newX][newY] == "S" && currentState.visited == .C && altitude > 10000 {
                        return steps + 1
                    }
                    if grid[newX][newY] == "#" || grid[newX][newY] == "S" {
                        continue
                    }
                    let altitudeDiff = getAltitudeDifferential(grid: grid, at: (newX, newY))
                    let nextVisited = getNextVisited(
                        grid: grid, at: (newX, newY), current: currentState.visited)
                    let nextState = State2(
                        x: newX, y: newY, direction: newDirection, visited: nextVisited)
                    let nextAltitude = altitude + altitudeDiff
                    if visitedBest[nextState, default: 0] >= nextAltitude {
                        continue
                    }
                    visitedBest[nextState] = nextAltitude
                    nextQueue[nextState] = max(nextAltitude, nextQueue[nextState] ?? 0)
                }
            }
            queue = nextQueue
            steps += 1
        }
        return -1
    }

    private static func part1() {
        let input = readInputLines(quest: 20, part: 1)
        let grid = input.map { Array($0) }
        let startPos = findOccurences(grid: grid, target: "S")[0]
        let result = bfs(grid: grid, start: startPos)
        print(result)
    }

    private static func part2() {
        let input = readInputLines(quest: 20, part: 2)
        let grid = input.map { Array($0) }
        let startPos = findOccurences(grid: grid, target: "S")[0]
        let result = bfs2(grid: grid, start: startPos)
        print(result)
    }

    private static func part3() {
        let input = readInputLines(quest: 20, part: 3)
        let grid = input.map { Array($0) }
        let stepsRight = 5
        let startPos = findOccurences(grid: grid, target: "S")[0]
        var altitude = 384400 - stepsRight
        var steps = 0
        while altitude > 0 {
            steps += 1
            let currentCell = grid[steps % grid.count][startPos.1 + stepsRight]
            if currentCell != "+" {
                altitude -= 1
            } else {
                altitude += 1
            }
        }
        print(steps)
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
