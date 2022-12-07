import Foundation

public enum Puzzle: String, CaseIterable {
    case partOne
    case partTwo
}

protocol Solution {
    func runPartOne(input: Data) async throws -> String
    func runPartTwo(input: Data) async throws -> String
}

// MARK: - Solution Map

public enum Day: Int {
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
}

extension Day {
    var solution: any Solution {
        switch self {
        case .one:
            return Day01()
        case .two:
            return Day02()
        case .three:
            return Day03()
        case .four:
            return Day04()
        case .five:
            return Day05()
        case .six:
            return Day06()
        case .seven:
            return Day07()
        }
    }
}

// MARK: - Runtime

struct NotImplemented: Error {}

public func runSolution(for day: Day, puzzle: Puzzle, input: Data) async throws {
    do {
        switch puzzle {
        case .partOne:
            try await printAnswer(day.solution.runPartOne(input: input))
        case .partTwo:
            try await printAnswer(day.solution.runPartTwo(input: input))
        }
    } catch is NotImplemented {
        print("Not yet implemented")
    } catch {
        print("Unexpected error: \(error)")
    }
}

private func printAnswer(_ answer: String) {
    print("The answer is: \(answer)")
}

// MARK: - Utility

func utf8String(from data: Data) -> String {
    // Force unwrap here because if it fails, the input is bad anyway.
    let string = String(data: data, encoding: .utf8)!
    // Sanitize the input, for some reason the input file seems to have
    // a trailing new line that breaks the parsers.
    return string.trimmingCharacters(in: .whitespacesAndNewlines)
}

