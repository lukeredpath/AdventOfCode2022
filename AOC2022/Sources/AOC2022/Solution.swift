public enum Day: Int {
    case one = 1
    case two
}

public enum Puzzle: String {
    case partOne = "Part One"
    case partTwo = "Part Two"
}

protocol Solution {
    func runPartOne() async throws
    func runPartTwo() async throws
}

public func notImplemented() {
    print("Solution not yet implemented")
}

public func runSolution(for day: Day, puzzle: Puzzle) async throws {
    switch day {
    case .one:
        try await runSolution(Day01(), puzzle: puzzle)
    case .two:
        try await runSolution(Day02(), puzzle: puzzle)
    }
}

private func runSolution(_ solution: Solution, puzzle: Puzzle) async throws {
    switch puzzle {
    case .partOne:
        try await solution.runPartOne()
    case .partTwo:
        try await solution.runPartTwo()
    }
}
