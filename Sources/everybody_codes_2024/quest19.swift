enum Quest19 {

    private static func rotate<T>(
        _ grid: inout [[T]], _ direction: Character, _ pivot: (Int, Int)
    ) {
        let targets = [
            (pivot.0 - 1, pivot.1 - 1), (pivot.0 - 1, pivot.1), (pivot.0 - 1, pivot.1 + 1),
            (pivot.0, pivot.1 - 1), (pivot.0, pivot.1 + 1),
            (pivot.0 + 1, pivot.1 - 1), (pivot.0 + 1, pivot.1), (pivot.0 + 1, pivot.1 + 1),
        ]
        let buffer = targets.map { grid[$0.0][$0.1] }
        switch direction {
        case "L":
            grid[targets[0].0][targets[0].1] = buffer[1]
            grid[targets[1].0][targets[1].1] = buffer[2]
            grid[targets[2].0][targets[2].1] = buffer[4]
            grid[targets[4].0][targets[4].1] = buffer[7]
            grid[targets[7].0][targets[7].1] = buffer[6]
            grid[targets[6].0][targets[6].1] = buffer[5]
            grid[targets[5].0][targets[5].1] = buffer[3]
            grid[targets[3].0][targets[3].1] = buffer[0]
        case "R":
            grid[targets[0].0][targets[0].1] = buffer[3]
            grid[targets[3].0][targets[3].1] = buffer[5]
            grid[targets[5].0][targets[5].1] = buffer[6]
            grid[targets[6].0][targets[6].1] = buffer[7]
            grid[targets[7].0][targets[7].1] = buffer[4]
            grid[targets[4].0][targets[4].1] = buffer[2]
            grid[targets[2].0][targets[2].1] = buffer[1]
            grid[targets[1].0][targets[1].1] = buffer[0]
        default:
            fatalError("Invalid rotation direction")
        }
    }

    private static func executeCommands<T>(grid: inout [[T]], commands: [Character]) {
        var pivot = (1, 1)
        var commandIndex = 0
        while pivot.0 < grid.count - 1 {
            rotate(&grid, commands[commandIndex % commands.count], pivot)
            commandIndex += 1
            if pivot.1 < grid[0].count - 2 {
                pivot.1 += 1
            } else {
                pivot.1 = 1
                pivot.0 += 1
            }
        }
    }

    private static func transform<T>(grid: [[T]], mapping: [[(Int, Int)]]) -> [[T]] {
        var newGrid = grid
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                let (newI, newJ) = mapping[i][j]
                newGrid[i][j] = grid[newI][newJ]
            }
        }
        return newGrid
    }

    private static func part1() {
        let input = readInputLines(quest: 19, part: 1)
        let commands = Array(input[0])
        var grid = input[2...].map { Array($0) }
        executeCommands(grid: &grid, commands: commands)
        for row in grid {
            print(String(row))
        }
    }

    private static func part2() {
        let input = readInputLines(quest: 19, part: 2)
        let commands = Array(input[0])
        var grid = input[2...].map { Array($0) }
        for _ in 0..<100 {
            executeCommands(grid: &grid, commands: commands)
        }
        for row in grid {
            print(String(row))
        }
    }

    private static func part3() {
        let input = readInputLines(quest: 19, part: 3)
        let commands = Array(input[0])
        let target = 1_048_576_000
        let grid = input[2...].map { Array($0) }
        let originalGrid = grid.indexed().map { (i, row) in
            row.indexed().map { (j, _) in
                (Int(i), Int(j))
            }
        }
        var rotations = [[[(Int, Int)]]]()

        var firstTransform = originalGrid
        executeCommands(grid: &firstTransform, commands: commands)
        rotations.append(firstTransform)
        for _ in 1...30 {
            let currentTransform = transform(grid: rotations.last!, mapping: rotations.last!)
            rotations.append(currentTransform)
        }

        var current = originalGrid
        var left = target
        for k in (0..<30).reversed() {
            if left >= (1 << k) {
                current = transform(grid: current, mapping: rotations[k])
                left -= (1 << k)
            }
        }
        let finalGrid = transform(grid: grid, mapping: current)
        for row in finalGrid {
            print(String(row))
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
