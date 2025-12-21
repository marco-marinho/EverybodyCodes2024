import Foundation

enum Quest08 {

    @inline(__always)
    private static func getThickness(input: Int, ratio: Int, modulo: Int)
        -> Int
    {
        return (input * ratio) % modulo
    }

    @inline(__always)
    private static func layerSize(layer: Int) -> Int {
        return 2 * (layer - 1) + 1
    }

    @inline(__always)
    private static func getThicknessThree(input: Int, ratio: Int, modulo: Int) -> Int {
        return ((input * ratio) % modulo) + modulo
    }

    @inline(__always)
    private static func removeCols(layer: inout Int) {

    }

    private static func part1() {
        let input = 4_097_633
        let closestSquare = Int(sqrt(Double(input)).rounded(.up))
        let totalCells = closestSquare * closestSquare
        let baseSize = layerSize(layer: closestSquare)
        print((totalCells - input) * baseSize)
    }

    private static func part2() {
        var available = 20_240_000 - 1
        var currentThickness = 1
        var layer = 1
        while available > 0 {
            layer += 1
            currentThickness = getThickness(
                input: currentThickness,
                ratio: 924,
                modulo: 1111
            )
            available -= layerSize(layer: layer) * currentThickness
        }
        print(abs(available) * (2 * (layer - 1) + 1))
    }

    private static func part3() {
        let priests = 945117
        let accolites = 10
        var available = 202_400_000
        var currentThickness = [1]
        var lastAddedThickness = 1
        var layer = 1
        while true {
            layer += 1
            lastAddedThickness = getThicknessThree(
                input: lastAddedThickness,
                ratio: priests,
                modulo: accolites
            )
            let buff = currentThickness
            currentThickness = [Int](repeating: lastAddedThickness, count: buff.count + 2)
            for i in 0..<buff.count {
                currentThickness[i + 1] += buff[i]
            }
            let ratio = currentThickness.count * priests
            var needed = currentThickness[0] + currentThickness.last!
            for i in 1..<(currentThickness.count - 1) {
                needed +=
                    currentThickness[i] - ((ratio * currentThickness[i]) % accolites)
            }
            if needed > available {
                available -= needed
                break
            }
        }
        print(abs(available))
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
