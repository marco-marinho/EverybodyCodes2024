enum Quest04 {

    private static func median(of numbers: [Int]) -> Int {
        let sorted = numbers.sorted()
        let count = sorted.count
        if count % 2 == 1 {
            return sorted[count / 2]
        } else {
            return (sorted[count / 2 - 1] + sorted[count / 2]) / 2
        }
    }

    private static func part1() {
        let input = readInputLines(quest: 4, part: 1).map { Int($0)! }
        let min = input.min()!
        let diffs = input.map { $0 - min }
        print(diffs.reduce(0, +))
    }

    private static func part2() {
        let input = readInputLines(quest: 4, part: 2).map { Int($0)! }
        let min = input.min()!
        let diffs = input.map { $0 - min }
        print(diffs.reduce(0, +))
    }

    private static func part3() {
        let input = readInputLines(quest: 4, part: 3).map { Int($0)! }
        let median = median(of: input)
        let diffs = input.map { abs($0 - median) }
        print(diffs.reduce(0, +))
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
