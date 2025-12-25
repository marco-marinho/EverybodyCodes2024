import Collections

enum Quest17 {

    private static func setFirst(_ array: inout [Bool]) -> Int {
        for (index, value) in array.enumerated() {
            if !value {
                array[index] = true
                return index
            }
        }
        return -1
    }

    private static func primsMax(
        stars: borrowing [(Int, Int)], distances: inout [Int], added: inout [Bool], maxDistance: Int
    ) -> [Int] {

        var block = [Int]([0])
        var lastAdded = setFirst(&added)
        distances[lastAdded] = 0
        added[lastAdded] = true

        var foundOne = true

        for _ in 1..<stars.count {
            var minDistance = Int.max
            var minIndex = -1
            foundOne = false
            for i in 0..<stars.count {
                if added[i] { continue }
                let dist =
                    abs(stars[lastAdded].0 - stars[i].0)
                    + abs(stars[lastAdded].1 - stars[i].1)
                distances[i] = min(distances[i], dist)
                if distances[i] < minDistance && distances[i] <= maxDistance {
                    minDistance = distances[i]
                    minIndex = i
                    foundOne = true
                }
            }
            if !foundOne {
                break
            }
            added[minIndex] = true
            lastAdded = minIndex
            block.append(distances[minIndex])
        }
        return block
    }

    private static func prims(stars: borrowing [(Int, Int)]) -> [Int] {
        var distances = [Int](repeating: Int.max, count: stars.count)
        var added = [Bool](repeating: false, count: stars.count)

        var lastAdded = 0
        distances[0] = 0
        added[0] = true

        for _ in 1..<stars.count {
            var minDistance = Int.max
            var minIndex = -1
            for i in 0..<stars.count {
                if added[i] { continue }
                let dist =
                    abs(stars[lastAdded].0 - stars[i].0)
                    + abs(stars[lastAdded].1 - stars[i].1)
                distances[i] = min(distances[i], dist)
                if distances[i] < minDistance {
                    minDistance = distances[i]
                    minIndex = i
                }
            }
            added[minIndex] = true
            lastAdded = minIndex
        }
        return distances
    }

    private static func part1() {
        let grid = readInputLines(quest: 17, part: 1).map { Array($0) }
        let stars = findOccurences(grid: grid, target: "*")
        let distances = prims(stars: stars)
        print(distances.reduce(0, +) + stars.count)
    }

    private static func part2() {
        let grid = readInputLines(quest: 17, part: 2).map { Array($0) }
        let stars = findOccurences(grid: grid, target: "*")
        let distances = prims(stars: stars)
        print(distances.reduce(0, +) + stars.count)
    }

    private static func part3() {
        let grid = readInputLines(quest: 17, part: 3).map { Array($0) }
        let stars = findOccurences(grid: grid, target: "*")
        var distanceBlocks = [[Int]]()
        var distance = [Int](repeating: Int.max, count: stars.count)
        var added = [Bool](repeating: false, count: stars.count)
        var numAdded = 0
        while numAdded < stars.count {
            let block = primsMax(
                stars: stars, distances: &distance, added: &added, maxDistance: 5)
            distanceBlocks.append(block)
            numAdded += block.count
        }
        print(
            distanceBlocks.map { $0.count + $0.reduce(0, +) }.sorted(by: >).prefix(3).reduce(1, *))
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
