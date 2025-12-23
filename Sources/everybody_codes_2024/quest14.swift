import Collections

enum Quest14 {

    private struct Node: Comparable {
        let position: Coordinate3D
        let cost: Int

        static func < (lhs: Node, rhs: Node) -> Bool {
            return lhs.cost < rhs.cost
        }

        static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.position == rhs.position && lhs.cost == rhs.cost
        }

        var pair: IntPair { IntPair(x: position.x, y: position.y) }
    }

    private struct Command {
        let direction: Character
        let distance: Int
    }

    private struct Coordinate3D: Hashable {
        let x: Int
        let y: Int
        let z: Int

        static func + (lhs: Coordinate3D, rhs: Coordinate3D) -> Coordinate3D {
            return Coordinate3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
        }
    }

    private static func grow(state: (Int, Int, Int), command: Command) -> (Int, Int, Int) {
        var (x, y, z) = state
        switch command.direction {
        case "U": y += command.distance
        case "D": y -= command.distance
        case "L": x -= command.distance
        case "R": x += command.distance
        case "F": z += command.distance
        case "B": z -= command.distance
        default:
            fatalError("Unknown direction \(command.direction)")
        }
        return (x, y, z)
    }

    private static func getDelta(command: Command) -> Coordinate3D {
        switch command.direction {
        case "U": return Coordinate3D(x: 0, y: 1, z: 0)
        case "D": return Coordinate3D(x: 0, y: -1, z: 0)
        case "L": return Coordinate3D(x: -1, y: 0, z: 0)
        case "R": return Coordinate3D(x: 1, y: 0, z: 0)
        case "F": return Coordinate3D(x: 0, y: 0, z: 1)
        case "B": return Coordinate3D(x: 0, y: 0, z: -1)
        default:
            fatalError("Unknown direction \(command.direction)")
        }
    }

    private static func registeBranches(
        acc: inout Set<Coordinate3D>, state: Coordinate3D, command: Command
    ) -> Coordinate3D {
        var newState = state
        let delta = getDelta(command: command)
        for _ in 0..<command.distance {
            newState = newState + delta
            acc.insert(newState)
        }
        return newState
    }

    private static func bfs(
        grid: borrowing Set<Coordinate3D>, start: Coordinate3D, solutionLength: Int
    )
        -> [Int: Node]
    {
        var queue = Deque<Node>()
        queue.append(Node(position: start, cost: 0))
        var visited = Set<Coordinate3D>()
        var solutions = [Int: Node]()
        while !queue.isEmpty {
            let current = queue.popFirst()!
            if current.position.x == 0 && current.position.z == 0 {
                solutions[current.position.y] = current
                if solutions.count == solutionLength {
                    return solutions
                }
            }
            if visited.contains(current.position) {
                continue
            }
            visited.insert(current.position)
            let directions = [
                Coordinate3D(x: 0, y: 1, z: 0), Coordinate3D(x: 1, y: 0, z: 0),
                Coordinate3D(x: 0, y: -1, z: 0), Coordinate3D(x: -1, y: 0, z: 0),
                Coordinate3D(x: 0, y: 0, z: 1), Coordinate3D(x: 0, y: 0, z: -1),
            ]
            for direction in directions {
                let newCoordinate = current.position + direction
                if !grid.contains(newCoordinate) || visited.contains(newCoordinate) {
                    continue
                }
                let newNode = Node(
                    position: newCoordinate, cost: current.cost + 1)
                queue.append(newNode)
            }
        }
        fatalError("Could not find all solutions")
    }

    private static func part1() {
        let input = readInputLines(quest: 14, part: 1)
        let commands = input[0].split(separator: ",").map { segment -> Command in
            let direction = segment.first!
            let distance = Int(segment.dropFirst())!
            return Command(direction: direction, distance: distance)
        }
        let states = commands.reductions((0, 0, 0), grow)
        let result = states.map { $0.1 }.max()
        print(result!)
    }

    private static func part2() {
        let input = readInputLines(quest: 14, part: 2)
        let commandList = input.map { line -> [Command] in
            line.split(separator: ",").map { segment -> Command in
                let direction = segment.first!
                let distance = Int(segment.dropFirst())!
                return Command(direction: direction, distance: distance)
            }
        }
        var branches = Set<Coordinate3D>()
        for commands in commandList {
            var state = Coordinate3D(x: 0, y: 0, z: 0)
            for command in commands {
                state = registeBranches(acc: &branches, state: state, command: command)
            }
        }
        print(branches.count)
    }

    private static func part3() {
        let input = readInputLines(quest: 14, part: 3)
        let commandList = input.map { line -> [Command] in
            line.split(separator: ",").map { segment -> Command in
                let direction = segment.first!
                let distance = Int(segment.dropFirst())!
                return Command(direction: direction, distance: distance)
            }
        }
        var branches = Set<Coordinate3D>()
        var leafs = [Coordinate3D]()
        for commands in commandList {
            var state = Coordinate3D(x: 0, y: 0, z: 0)
            for command in commands {
                state = registeBranches(acc: &branches, state: state, command: command)
            }
            leafs.append(state)
        }
        let mainBranch = branches.filter { $0.x == 0 && $0.z == 0 }
        let brachYs = mainBranch.map { $0.y }.sorted()
        var costs = [Int: Int]()
        let leafCosts = leafs.map {
            bfs(grid: branches, start: $0, solutionLength: mainBranch.count)
        }

        for y in brachYs {
            for leafCost in leafCosts {
                costs[y, default: 0] += leafCost[y]!.cost
            }
        }
        print(costs.values.min()!)
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
