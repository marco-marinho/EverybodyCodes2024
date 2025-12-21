enum Quest11 {

    private static func mutate(
        target: String,
        steps: Int,
        conversions: [String: [String]],
    ) -> Int {
        var current = [target: 1]
        for _ in 1...steps {
            var next = [String: Int]()
            for (char, count) in current {
                let mutations = conversions[char]!
                for mutation in mutations {
                    next[mutation, default: 0] += count
                }
            }
            current = next
        }
        return current.values.reduce(0, +)
    }

    private static func parseInput(_ input: [String]) -> [String: [String]] {
        let conversions = input.reduce(
            into: [String: [String]](),
            { dict, line in
                let halves = line.split(separator: ":")
                let key = String(halves[0])
                let value = halves[1].split(separator: ",").map { String($0) }
                dict[key] = value
            })
        return conversions
    }

    private static func part1() {
        let input = readInputLines(quest: 11, part: 1)
        let conversions = parseInput(input)
        let result = mutate(target: "A", steps: 4, conversions: conversions)
        print(result)
    }

    private static func part2() {
        let input = readInputLines(quest: 11, part: 2)
        let conversions = parseInput(input)
        let result = mutate(target: "Z", steps: 10, conversions: conversions)
        print(result)
    }

    private static func part3() {
        let input = readInputLines(quest: 11, part: 3)
        let conversions = parseInput(input)
        var maxCount = Int.min
        var minCount = Int.max
        for char in conversions.keys {
            let count = mutate(target: char, steps: 20, conversions: conversions)
            maxCount = max(maxCount, count)
            minCount = min(minCount, count)
        }
        print(maxCount - minCount)
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
