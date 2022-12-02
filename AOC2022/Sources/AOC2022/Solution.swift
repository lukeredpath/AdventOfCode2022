import Foundation

public enum Day: Int {
    case one = 1
    case two
}

public enum Puzzle: String, CaseIterable {
    case partOne
    case partTwo
}

protocol Solution {
    func runPartOne(input: Data) async throws
    func runPartTwo(input: Data) async throws
}

public func notImplemented() {
    print("Solution not yet implemented")
}

public func runSolution(for day: Day, puzzle: Puzzle, input: Data) async throws {
    switch day {
    case .one:
        try await runSolution(Day01(), puzzle: puzzle, input: input)
    case .two:
        try await runSolution(Day02(), puzzle: puzzle, input: input)
    }
}

private func runSolution(_ solution: Solution, puzzle: Puzzle, input: Data) async throws {
    switch puzzle {
    case .partOne:
        try await solution.runPartOne(input: input)
    case .partTwo:
        try await solution.runPartTwo(input: input)
    }
}
