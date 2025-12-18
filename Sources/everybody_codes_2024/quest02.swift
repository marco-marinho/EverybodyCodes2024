enum Quest02 {

    private static func countRunic(phrase: String, runic: [String]) -> Int {
        var flags = [Bool](repeating: false, count: phrase.count)
        for idx in phrase.indices {
            for rune in runic {
                if phrase[idx...].starts(with: rune){
                    let startIdx = phrase.distance(from: phrase.startIndex, to: idx)
                    let endIdx = startIdx + rune.count - 1
                    for i in startIdx...endIdx {
                        flags[i] = true
                    }
                }
            }
        }
        return flags.filter{ $0 }.count
    }

    private static func countRunicCylindrical(grid: [[Character]], runic: [String]) -> Int {
        let rows = grid.count 
        let cols = grid[0].count
        var flags = [[Bool]](repeating: [Bool](repeating: false, count: cols), count: rows)
        let runicChars = runic.map { Array($0) }
        for row in 0..<rows {
            for col in 0..<cols {
                for runeIdx in runicChars.indices {
                    let runeSize = runicChars[runeIdx].count
                    for k in 0..<runeSize {
                        let modCol = (col + k) % cols
                        if grid[row][modCol] != runicChars[runeIdx][k] {
                            break
                        }
                        if k == runeSize - 1 {
                            for m in 0..<runeSize {
                                let markCol = (col + m) % cols
                                flags[row][markCol] = true
                            }
                        }
                    }
                    if runeSize > rows - row {
                        continue
                    }
                    for k in 0..<runeSize {
                        if grid[row + k][col] != runicChars[runeIdx][k] {
                            break
                        }
                        if k == runeSize - 1 {
                            for m in 0..<runeSize {
                                flags[row + m][col] = true
                            }
                        }
                    }
                }
            }
        }
        return flags.map { $0.filter{ $0 }.count }.reduce(0, +)
    }

    private static func appendReversed(parts: [Substring.SubSequence]) -> [String] {
        var runic = [String]()
        for part in parts {runic.append(String(part))}
        for part in parts {runic.append(String(part.reversed()))}
        return runic
    }

    private static func part1(){
        let input = readInputLines(quest: 2, part: 1)
        let runic = input[0].split(separator: ":")[1].split(separator: ",")
        let phrase = input[2]
        var count = 0;
        for idx in phrase.indices {
            for rune in runic {
                if phrase[idx...].starts(with: rune){
                    count += 1    
                }
            }
        }
        print(count)
    }

    private static func part2(){
        let input = readInputLines(quest: 2, part: 2)
        let phrases = input[2...]
        let parts = input[0].split(separator: ":")[1].split(separator: ",")
        let runic = appendReversed(parts: parts)
        let result = phrases.reduce(0) { partialResult, phrase in
            partialResult + countRunic(phrase: String(phrase), runic: runic)
        } 
        print(result)
    }

    private static func part3(){
        let input = readInputLines(quest: 2, part: 3)
        let phrases = input[2...]
        let parts = input[0].split(separator: ":")[1].split(separator: ",")
        let runic = appendReversed(parts: parts)
        let grid = phrases.map { Array($0) }
        let result = countRunicCylindrical(grid: grid, runic: runic)
        print(result)
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