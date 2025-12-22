import Algorithms

enum Quest12 {

    private static func calcScore(hit: (Character, Character, Int)) -> Int {
        let (catId, tgtId, power) = hit
        let catMultiplier =
            switch catId {
            case "A": 1
            case "B": 2
            case "C": 3
            default: 0
            }
        let tgtMultiplier =
            switch tgtId {
            case "T": 1
            case "H": 2
            default: 0
            }
        return catMultiplier * tgtMultiplier * power
    }

    private static func destroyColumn(
        catapults: [(Character, Int, Int)], targets: ArraySlice<(Character, Int, Int)>
    )
        -> [(Character, Character, Int)]
    {
        var destroyed = [(Character, Character, Int)]()
        for (catId, catRow, catCol) in catapults {
            for (tgtId, tgtRow, tgtCol) in targets {
                let deltaRow = tgtRow - catRow
                let deltaCol = tgtCol - catCol
                if (deltaCol - deltaRow) % 3 == 0 {
                    destroyed.append((catId, tgtId, ((deltaCol - deltaRow) / 3)))
                    break
                }
            }
        }
        return destroyed
    }

    private static func dry(part: Int) -> Int {
        let lines = readInputLines(quest: 12, part: part)
        var catapults = [(Character, Int, Int)]()
        var targets = [(Character, Int, Int)]()
        for (row, line) in lines.enumerated() {
            for (col, char) in line.enumerated() {
                if char != "T" && char != "." && char != "=" && char != "H" {
                    catapults.append((char, row, col))
                } else if char == "T" || char == "H" {
                    targets.append((char, row, col))
                }
            }
        }
        let target_cols = targets.chunked(on: { $0.2 }).map { $0.1 }
        let hits = target_cols.flatMap { destroyColumn(catapults: catapults, targets: $0) }
        let totalScore = hits.map { calcScore(hit: $0) }.reduce(0, +)
        return totalScore
    }

    private static func part1() {
        print(dry(part: 1))
    }

    private static func part2() {
        print(dry(part: 2))
    }

    private static func part3() {
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
