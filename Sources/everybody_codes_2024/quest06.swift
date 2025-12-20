enum Quest06 {

    private static func parseLine(line: String) -> (String, [String]) {
        let halves = line.split(separator: ":").map { String($0) }
        let name = halves[0]
        let connections = halves[1].split(separator: ",").map {
            String($0.trimmingCharacters(in: .whitespaces))
        }
        return (name, connections)
    }

    private static func dfs(
        node: String, graph: [String: [String]], current: inout [String], solutions: inout [String]
    ) {
        if current.contains(node) {
            return
        }
        current.append(node)
        if node == "@" {
            let solution = current.joined(separator: ",")
            solutions.append(solution)
        } else {
            let neighbors = graph[node, default: []]
            for neighbor in neighbors {
                dfs(node: neighbor, graph: graph, current: &current, solutions: &solutions)
            }
        }
        current.removeLast()
    }

    private static func solve(graph: [String: [String]]) -> String {
        var current: [String] = []
        var solutions = [String]()
        dfs(node: "RR", graph: graph, current: &current, solutions: &solutions)
        let connections = solutions.map { $0.split(separator: ",").count + 1 }
        let counts = connections.reduce(into: [Int: Int]()) { dict, count in
            dict[count, default: 0] += 1
        }
        let (key, _) = counts.min(by: { $0.value < $1.value })!
        let result = solutions.filter {
            $0.split(separator: ",").count + 1 == key
        }
        return result[0]
    }

    private static func parse(part: Int) -> [String: [String]] {
        let input = readInputLines(quest: 6, part: part)
        let graph = input.reduce(into: [String: [String]]()) { dict, line in
            let (name, connections) = parseLine(line: line)
            dict[name] = connections
        }
        return graph
    }

    private static func part1() {
        let result = solve(graph: parse(part: 1))
        print(result.replacingOccurrences(of: ",", with: ""))
    }

    private static func part2() {
        let graph = parse(part: 2)
        let result = solve(graph: graph).split(separator: ",").map({ String($0.first!) }).joined()
        print(result)
    }

    private static func part3() {
        let graph = parse(part: 3)
        let result = solve(graph: graph).split(separator: ",").map({ String($0.first!) }).joined()
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
