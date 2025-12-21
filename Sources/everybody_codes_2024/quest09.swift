import Foundation

enum Quest09 {

    private static func countFactors(of number: Int, factors: [Int]) -> Int {
        var current = number
        var totalFactors = 0
        for factor in factors {
            totalFactors += current / factor
            current = current % factor
        }
        return totalFactors
    }

    private static func dp(value: Int, idx: Int, factors: [Int], memo: inout [IntPair: Int]) -> Int
    {
        if value == 0 {
            return 0
        }
        if idx >= factors.count {
            return Int.max / 2
        }
        let key = IntPair(x: value, y: idx)
        if let cached = memo[key] {
            return cached
        }
        let factor = factors[idx]
        if value < factor {
            let result = dp(value: value, idx: idx + 1, factors: factors, memo: &memo)
            memo[key] = result
            return result
        }
        let useIt = 1 + dp(value: value - factor, idx: idx, factors: factors, memo: &memo)
        let skipIt = dp(value: value, idx: idx + 1, factors: factors, memo: &memo)
        let best = min(useIt, skipIt)
        memo[key] = best
        return best
    }

    private static func optimalSplit(parts: (Int, Int), factors: [Int], memo: inout [IntPair: Int])
        -> Int
    {
        var bestTotal = Int.max
        for i in 0..<100 {
            if abs((parts.0 - i) - (parts.1 + i)) > 100 {
                break
            }
            let split1 = dp(value: parts.0 - i, idx: 0, factors: factors, memo: &memo)
            let split2 = dp(value: parts.1 + i, idx: 0, factors: factors, memo: &memo)
            bestTotal = min(bestTotal, split1 + split2)
        }
        return bestTotal
    }

    private static func part1() {
        let input = readInputLines(quest: 9, part: 1).map { Int($0)! }
        let factors = input.map { countFactors(of: $0, factors: [10, 5, 3, 1]) }
        let result = factors.reduce(0, +)
        print(result)
    }

    private static func part2() {
        let input = readInputLines(quest: 9, part: 2).map { Int($0)! }
        var memo: [IntPair: Int] = [:]
        let factors = input.map {
            dp(value: $0, idx: 0, factors: [30, 25, 24, 20, 16, 15, 10, 5, 3, 1], memo: &memo)
        }
        let result = factors.reduce(0, +)
        print(result)
    }

    private static func part3() {
        let input = readInputLines(quest: 9, part: 3).map { Int($0)! }.map {
            ($0 / 2, ($0 / 2) + ($0 % 2))
        }
        var memo: [IntPair: Int] = [:]
        let factors = Array(
            [1, 3, 5, 10, 15, 16, 20, 24, 25, 30, 37, 38, 49, 50, 74, 75, 100, 101].reversed())
        let counts = input.map {
            optimalSplit(
                parts: $0,
                factors: factors, memo: &memo)
        }
        print(counts.reduce(0, +))
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
