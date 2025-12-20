import Foundation

enum Quest08 {

    private static func getThickness(input: Int, ratio: Int, modulo: Int)
        -> Int
    {
        return (input * ratio) % modulo
    }

    private static func part1() {
        let input = 4_097_633
        let closestSquare = Int(sqrt(Double(input)).rounded(.up))
        let totalCells = closestSquare * closestSquare
        let baseSize = 2 * (closestSquare - 1) + 1
        print((totalCells - input) * baseSize)
    }

    private static func part2() {
        var available = 20_240_000 - 1
        var currentThickness = 1
        var layer = 1
        while available > 0 {
            currentThickness = getThickness(
                input: currentThickness,
                ratio: 924,
                modulo: 1111
            )
            layer += 1
            available -= ((2 * (layer - 1) + 1) * currentThickness)
        }
        print(abs(available) * (2 * (layer - 1) + 1))
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
