import Collections

enum Quest16 {

    private struct cacheKey: Hashable {
        let positions: [Int]
        let spinsLeft: Int
    }

    @inline(__always)
    private static func wrap(idx: Int, count: Int) -> Int {
        return (idx % count + count) % count
    }

    private static func parseFacesBS(grid: borrowing [[Character]], cols: Int) -> [[String]] {
        let rows = grid.count
        var output = [[String]](
            repeating: [String](repeating: "", count: rows), count: cols)
        for row in 0..<rows {
            for col in 0..<cols {
                output[col][row] = String(grid[row][(col * 4)..<(col * 4 + 3)])
            }
        }
        for col in 0..<cols {
            output[col] = output[col].filter { !$0.isEmpty && !$0.allSatisfy { $0 == " " } }
        }
        return output
    }

    private static func parseFaces(grid: borrowing [[Character]], cols: Int) -> [[[Character: Int]]]
    {
        let rows = grid.count
        var output = [[[Character: Int]]](
            repeating: [[Character: Int]](repeating: [Character: Int](), count: rows), count: cols)
        for row in 0..<rows {
            for col in 0..<cols {
                for i in [0, 2] {
                    let cell = grid[row][(col * 4) + i]
                    if cell == " " {
                        continue
                    }
                    output[col][row][cell, default: 0] += 1
                }
            }
        }
        for col in 0..<cols {
            output[col] = output[col].filter { !$0.isEmpty }
        }
        return output
    }

    private static func calcScore(
        faces: borrowing [[[Character: Int]]],
        positions: borrowing [Int]
    ) -> Int {
        var count = [Character: Int]()
        for i in 0..<positions.count {
            for (key, value) in faces[i][positions[i]] {
                count[key, default: 0] += value
            }
        }
        var score = 0
        for value in count.values {
            if value >= 3 {
                score += 1 + (value - 3)
            }
        }
        return score
    }

    private static func dfs(
        faces: borrowing [[[Character: Int]]], spins: [Int], state: [Int], spinsLeft: Int,
        cache: inout [cacheKey: (Int, Int)]
    ) -> (Int, Int) {
        let currentVal = calcScore(faces: faces, positions: state)
        if spinsLeft == 0 {
            return (currentVal, currentVal)
        }
        if let cached = cache[cacheKey(positions: state, spinsLeft: spinsLeft)] {
            return cached
        }
        var minVal = Int.max
        var maxVal = Int.min
        for offset in [1, 0, -1] {
            let nextState = spins.enumerated().map {
                wrap(idx: state[$0.offset] + $0.element + offset, count: faces[$0.offset].count)
            }
            let (minNext, maxNext) = dfs(
                faces: faces, spins: spins, state: nextState, spinsLeft: spinsLeft - 1,
                cache: &cache)
            minVal = min(minVal, minNext)
            maxVal = max(maxVal, maxNext)
        }
        cache[cacheKey(positions: state, spinsLeft: spinsLeft)] = (
            minVal + currentVal,
            maxVal + currentVal
        )
        return (minVal + currentVal, maxVal + currentVal)
    }

    private static func part1() {
        let input = readInputLines(quest: 16, part: 1)
        let spins = input[0].split(separator: ",").map { Int($0)! }
        let cols = spins.count
        let grid = input[2...].map { Array($0) }
        let faces = parseFacesBS(grid: grid, cols: cols)
        let spinCount = 100
        let finalPositions = spins.enumerated().map {
            ($0.element * spinCount) % faces[$0.offset].count
        }
        let finalFaces = finalPositions.enumerated().map {
            faces[$0.offset][$0.element]
        }
        print(finalFaces.joined(separator: " "))
    }

    private static func part2() {
        let neededSpins = 202_420_242_024 + 1
        let input = readInputLines(quest: 16, part: 2)
        let spins = input[0].split(separator: ",").map { Int($0)! }
        let cols = spins.count
        let grid = input[2...].map { Array($0) }
        let faces = parseFaces(grid: grid, cols: cols)
        var seen = Set<[Int]>()
        var spinCycle = 0
        var score = 0
        for spinCount in 1..<neededSpins {
            let positions = spins.enumerated().map {
                ($0.element * spinCount) % faces[$0.offset].count
            }
            if seen.contains(positions) {
                spinCycle = spinCount - 1
                break
            }
            seen.insert(positions)
            let roundScore = calcScore(faces: faces, positions: positions)
            score += roundScore
        }
        score = score * (neededSpins / spinCycle)
        let remainder = neededSpins % spinCycle
        for spinCount in 1..<remainder {
            let positions = spins.enumerated().map {
                ($0.element * spinCount) % faces[$0.offset].count
            }
            let roundScore = calcScore(faces: faces, positions: positions)
            score += roundScore
        }
        print(score)
    }

    private static func part3() {
        let input = readInputLines(quest: 16, part: 3)
        let spins = input[0].split(separator: ",").map { Int($0)! }
        let cols = spins.count
        let grid = input[2...].map { Array($0) }
        let faces = parseFaces(grid: grid, cols: cols)
        let first = calcScore(faces: faces, positions: [Int](repeating: 0, count: cols))
        var cache: [cacheKey: (Int, Int)] = [:]
        let (minScore, maxScore) = dfs(
            faces: faces, spins: spins, state: [Int](repeating: 0, count: cols), spinsLeft: 256,
            cache: &cache)
        print(maxScore - first, minScore - first)
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
