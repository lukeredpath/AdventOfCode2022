import AOC2022
import ArgumentParser
import Foundation

@main
struct Runtime: AsyncParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "aoc2022",
        abstract: "A command for running AOC2022 solutions"
    )

    @Argument(help: "Which day's puzzle to solve.")
    private var day: Day

    @Flag(help: "Which puzzle part to solve.")
    private var puzzle: Puzzle

    @Argument(help: "The input file for this puzzle.")
    private var inputFile: String

    mutating func run() async throws {
        print("Running solution for Day \(day.rawValue) (\(puzzle.description)).")
        print("Reading input from: \(inputFile)")
        try await runSolution(for: day, puzzle: puzzle, input: readInput())
    }

    private func readInput() throws -> Data {
        let manager = FileManager.default
        guard manager.fileExists(atPath: inputFile) else {
            throw Error.inputFileMissing
        }
        guard let inputData = manager.contents(atPath: inputFile) else {
            throw Error.inputDataCannotBeRead
        }
        return inputData
    }

    enum Error: Swift.Error {
        case inputFileMissing
        case inputDataCannotBeRead
    }
}

extension Day: ExpressibleByArgument {}

extension Puzzle: EnumerableFlag {
    var description: String {
        switch self {
        case .partOne:
            return "Part One"
        case .partTwo:
            return "Part Two"
        }
    }
}
