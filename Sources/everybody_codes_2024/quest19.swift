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

    private static func executeCommands<T>(grid: [[T]], commands: [Character]) -> [[T]] {
        var output = grid
        var pivot = (1, 1)
        var commandIndex = 0
        while pivot.0 < output.count - 1 {
            rotate(&output, commands[commandIndex % commands.count], pivot)
            commandIndex += 1
            if pivot.1 < output[0].count - 2 {
                pivot.1 += 1
            } else {
                pivot.1 = 1
                pivot.0 += 1
            }
        }
        return output
    }

    private static func transform<T>(grid: [[T]], mapping: [[(Int, Int)]]) -> [[T]] {
        var newGrid = grid
        for i in 0..<newGrid.count {
            for j in 0..<newGrid[0].count {
                let (newI, newJ) = mapping[i][j]
                newGrid[i][j] = grid[newI][newJ]
            }
        }
        return newGrid
    }

    private static func part1() {
        let input = readInputLines(quest: 19, part: 1)
        let commands = Array(input[0])
        let grid = input[2...].map { Array($0) }
        let result = executeCommands(grid: grid, commands: commands)
        for row in result {
            print(String(row))
        }
    }

    private static func part2() {
        let input = readInputLines(quest: 19, part: 2)
        let commands = Array(input[0])
        let grid = input[2...].map { Array($0) }
        var current = grid
        for _ in 0..<100 {
            current = executeCommands(grid: current, commands: commands)
        }
        for row in current {
            print(String(row))
        }
    }

    private static func part3() {
        let input = readInputLines(quest: 19, part: 3)
        let commands = Array(input[0])
        let target = 1_048_576_000
        let grid = input[2...].map { Array($0) }
        let identityMapping = grid.indexed().map { (i, row) in
            row.indexed().map { (j, _) in
                (Int(i), Int(j))
            }
        }

        var remaining = target
        var currentMapping = identityMapping
        var powerOfTwoMapping = executeCommands(grid: identityMapping, commands: commands)
        while remaining > 0 {
            if remaining & 1 == 1 {
                currentMapping = transform(grid: currentMapping, mapping: powerOfTwoMapping)
            }
            powerOfTwoMapping = transform(grid: powerOfTwoMapping, mapping: powerOfTwoMapping)
            remaining >>= 1
        }

        let finalGrid = transform(grid: grid, mapping: currentMapping)
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
