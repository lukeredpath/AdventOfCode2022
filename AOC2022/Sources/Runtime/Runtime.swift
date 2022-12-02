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

    @Option(help: "Which puzzle part to solve.")
    private var puzzle: Puzzle = .partOne

    mutating func run() async throws {
        print("Running solution for Day \(day.rawValue) (\(puzzle.rawValue)):")
        try await runSolution(for: day, puzzle: .partTwo)
    }
}

extension Day: ExpressibleByArgument {}
extension Puzzle: ExpressibleByArgument {}
