import Foundation

public enum Day: Int {
    case one = 1
    case two
    case three
}

public enum Puzzle: String, CaseIterable {
    case partOne
    case partTwo
}

protocol Solution {
    func runPartOne(input: Data) async throws -> String
    func runPartTwo(input: Data) async throws -> String
}

struct NotImplemented: Error {}

public func runSolution(for day: Day, puzzle: Puzzle, input: Data) async throws {
    do {
        switch day {
        case .one:
            try await runSolution(
                Day01(),
                puzzle: puzzle,
                input: input
            )
        case .two:
            try await runSolution(
                Day02(),
                puzzle: puzzle,
                input: input
            )
        case .three:
            try await runSolution(
                Day03(),
                puzzle: puzzle,
                input: input
            )
        }
    } catch is NotImplemented {
        print("Not yet implemented")
    } catch {
        print("Unexpected error: \(error)")
    }
}

private func runSolution(_ solution: Solution, puzzle: Puzzle, input: Data) async throws {
    switch puzzle {
    case .partOne:
        try await printAnswer(solution.runPartOne(input: input))
    case .partTwo:
        try await printAnswer(solution.runPartTwo(input: input))
    }
}

private func printAnswer(_ answer: String) {
    print("The answer is: \(answer)")
}
