enum Quest01 {

    private static func potionsNeeded(_ monster:Character) -> Int {
        switch monster {
            case "B": return 1
            case "C": return 3
            case "D": return 5
            default: return 0
        }
    }

    private static func calculateBlock(_ block: ArraySlice<Character>) -> Int {
        let validCount = block.filter{$0 != "x"}.count
        let potions = block.map { potionsNeeded($0)}.reduce(0, +)
        return potions + (validCount * (validCount - 1))
    }

    private static func part1(){
        let input = readInput(quest: 1, part: 1)
        let monsters = Array(input)
        let total = monsters.chunked(into: 1).map { calculateBlock($0) }.reduce(0, +)
        print(total)
    }

    private static func part2(){
        let input = readInput(quest: 1, part: 2)
        let monsters = Array(input)
        let total = monsters.chunked(into: 2).map { calculateBlock($0) }.reduce(0, +)
        print(total)
    }

    private static func part3(){
        let input = readInput(quest: 1, part: 3)
        let monsters = Array(input)
        let total = monsters.chunked(into: 3).map { calculateBlock($0) }.reduce(0, +)
        print(total)
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