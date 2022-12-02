import AOC2022
import ArgumentParser
import Foundation

@main
struct Runtime: AsyncParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "aoc2022",
        abstract: "A command for running AOC2022 solutions"
    )

    @Argument(help: "Which day's solution to run")
    private var solution: Solution

    mutating func run() async throws {
        print("Running solution for day \(solution.rawValue):")
        try await runSolution(solution)
    }
}

extension Solution: ExpressibleByArgument {}
