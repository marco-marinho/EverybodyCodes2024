enum Quest05 {

    private static func runRound(number: Int, board: inout [[Int]]) {
        let cols = board.count
        let currentCol = (number - 1) % cols
        let targetCol = number % cols
        let targetSize = board[targetCol].count
        let currentValue = board[currentCol][0]
        board[currentCol].remove(at: 0)
        var steps = abs((currentValue % (targetSize * 2)) - 1)
        if steps > targetSize {
            steps = (targetSize * 2) - steps
        }
        board[targetCol].insert(currentValue, at: steps)
    }

    private static func part1() {
        let input = readInputLines(quest: 5, part: 1)
        let cols = (input[0].count + 1) / 2
        let rows = input.count
        var stacks = [[Int]](repeating: [Int](repeating: 0, count: rows), count: cols)
        for (i, line) in input.enumerated() {
            let values = line.split(separator: " ").map { Int($0)! }
            for (j, char) in values.enumerated() {
                stacks[j][i] = char
            }
        }
        for round in 1...10 {
            runRound(number: round, board: &stacks)
        }
        for i in 0..<cols {
            print(stacks[i][0], terminator: "")
        }
        print()
    }

    private static func part2() {
        let input = readInputLines(quest: 5, part: 2)
        let cols = input[0].filter { $0 == " " }.count + 1
        let rows = input.count
        var stacks = [[Int]](repeating: [Int](repeating: 0, count: rows), count: cols)
        for (i, line) in input.enumerated() {
            let values = line.split(separator: " ").map { Int($0)! }
            for (j, char) in values.enumerated() {
                stacks[j][i] = char
            }
        }
        var counts: [String: Int] = [stacks.map { String($0[0]) }.joined(): 1]
        for round in 1...Int.max {
            runRound(number: round, board: &stacks)
            let key = stacks.map { String($0[0]) }.joined()
            let value = counts[key, default: 0]
            if value == 2023 {
                print(round * Int(key)!)
                break
            }
            counts[key] = value + 1
        }
    }

    private static func part3() {
        let input = readInputLines(quest: 5, part: 3)
        let cols = input[0].filter { $0 == " " }.count + 1
        let rows = input.count
        var stacks = [[Int]](repeating: [Int](repeating: 0, count: rows), count: cols)
        for (i, line) in input.enumerated() {
            let values = line.split(separator: " ").map { Int($0)! }
            for (j, char) in values.enumerated() {
                stacks[j][i] = char
            }
        }
        var state: Set<String> = [stacks.description]
        var currMax = 0
        for round in 1...Int.max {
            runRound(number: round, board: &stacks)
            let value = Int(stacks.map { String($0[0]) }.joined())!
            currMax = max(currMax, value)
            if state.contains(stacks.description) {
                print(currMax)
                break
            }
            state.insert(stacks.description)
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
