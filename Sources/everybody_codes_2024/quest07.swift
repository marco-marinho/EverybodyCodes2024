enum Quest07 {

    private static func parseLine(line: String) -> (String, [String]) {
        let halves = line.split(separator: ":").map { String($0) }
        let name = halves[0]
        let connections = halves[1].split(separator: ",").map {
            String($0.trimmingCharacters(in: .whitespaces))
        }
        return (name, connections)
    }

    private static func parse(input: [String]) -> [String: [String]] {
        let graph = input.reduce(into: [String: [String]]()) { dict, line in
            let (name, connections) = parseLine(line: line)
            dict[name] = connections
        }
        return graph
    }

    private static func parseTrack(input: [String]) -> [String] {
        let top = input[0].map { String($0) }.dropFirst()
        let right = input.dropFirst().map { String($0.last!) }.dropLast()
        let bottom = input.last!.reversed().map { String($0) }
        let left = input.map { String($0.first!) }.dropLast().reversed()
        return top + right + bottom + left
    }

    private static func parseTrackBS(input: [String]) -> [String] {
        let grid = input.map { Array($0) }
        var output = [String]()
        var row = 0
        var col = 1
        var visted = Set<IntPair>([IntPair(x: 0, y: 0)])
        while true {
            let current = String(grid[row][col])
            output.append(current)
            visted.insert(IntPair(x: row, y: col))
            if row - 1 >= 0 && !visted.contains(IntPair(x: row - 1, y: col))
                && grid[row - 1][col] != " "
            {
                row -= 1
            } else if row + 1 < grid.count && !visted.contains(IntPair(x: row + 1, y: col))
                && grid[row + 1][col] != " "
            {
                row += 1
            } else if col - 1 >= 0 && !visted.contains(IntPair(x: row, y: col - 1))
                && grid[row][col - 1] != " "
            {
                col -= 1
            } else if col + 1 < grid[0].count && !visted.contains(IntPair(x: row, y: col + 1))
                && grid[row][col + 1] != " "
            {
                col += 1
            } else {
                break
            }
        }
        output.append("S")
        return output
    }

    private static func executePlan(plan: [String], track: [String], steps: Int) -> Int {
        var result = 0
        var current = 10
        for idx in 0..<steps {
            switch (track[idx % track.count], plan[idx % plan.count]) {
            case ("-", _):
                current -= 1
            case ("+", _):
                current += 1
            case (_, "+"):
                current += 1
            case (_, "-"):
                current -= 1
            default:
                break
            }
            result += current
        }
        return result
    }

    private static func part1() {
        let input = readInputLines(quest: 7, part: 1)
        let plans = parse(input: input)
        let results = plans.map { ($0.key, executePlan(plan: $0.value, track: ["="], steps: 10)) }
        let results_sorted = results.sorted(by: { $0.1 > $1.1 })
        let letters = results_sorted.map { $0.0 }.joined()
        print(letters)
    }

    private static func part2() {
        let input = readInputLines(quest: 7, part: 2)
        let halves = input.split(separator: "")
        let plans = parse(input: Array(halves[0]))
        let track = parseTrack(input: Array(halves[1]))
        let results = plans.map {
            ($0.key, executePlan(plan: $0.value, track: track, steps: 10 * track.count))
        }
        let results_sorted = results.sorted(by: { $0.1 > $1.1 })
        let letters = results_sorted.map { $0.0 }.joined()
        print(letters)
    }

    private static func part3() {
        let input = readInputLines(quest: 7, part: 3)
        let halves = input.split(separator: "")
        let plans = parse(input: Array(halves[0]))
        let track = parseTrackBS(input: Array(halves[1]))
        let other_guy = executePlan(plan: plans["A"]!, track: track, steps: track.count * 11)
        let possible_plans = uniquePermutations(["+": 5, "-": 3, "=": 3])
        let possible_results = possible_plans.map {
            executePlan(plan: $0, track: track, steps: track.count * 11)
        }
        let valid_results = possible_results.filter { $0 > other_guy }
        print(valid_results.count)
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
