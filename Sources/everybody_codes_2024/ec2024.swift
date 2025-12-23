import Foundation

@main
struct EC2024 {
    static func main() {
        guard CommandLine.arguments.count >= 3 else {
            print("Usage: \(CommandLine.arguments[0]) <day> <part>")
            exit(1)
        }

        guard let quest = Int(CommandLine.arguments[1]),
            let part = Int(CommandLine.arguments[2])
        else {
            print("Error: Arguments must be integers")
            exit(1)
        }
        switch quest {
        case 1: Quest01.solve(part: part)
        case 2: Quest02.solve(part: part)
        case 3: Quest03.solve(part: part)
        case 4: Quest04.solve(part: part)
        case 5: Quest05.solve(part: part)
        case 6: Quest06.solve(part: part)
        case 7: Quest07.solve(part: part)
        case 8: Quest08.solve(part: part)
        case 9: Quest09.solve(part: part)
        case 10: Quest10.solve(part: part)
        case 11: Quest11.solve(part: part)
        case 12: Quest12.solve(part: part)
        case 13: Quest13.solve(part: part)
        case 14: Quest14.solve(part: part)
        case 15: Quest15.solve(part: part)
        default: print("Quest \(quest) not implemented yet.")
        }
    }
}
