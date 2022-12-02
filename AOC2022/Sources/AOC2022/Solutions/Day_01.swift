import Foundation
import Parsing

struct Day01: Solution {
    func runPartOne(input: Data) async throws -> String {
        let input = String(data: input, encoding: .utf8)!
        let calories = try Parsers.parseInput(input)
        let sorted = calories.sorted { $0 > $1 }
        return String(sorted.first!)
    }

    func runPartTwo(input: Data) async throws -> String {
        let input = String(data: input, encoding: .utf8)!
        let calories = try Parsers.parseInput(input)
        let topThreeTotal = calories.sorted { $0 > $1 }.prefix(3).reduce(0, +)
        return String(topThreeTotal)
    }

    enum Parsers {
        static func parseInput(_ input: String) throws -> [Int] {
            try allElves.parse(Substring(input))
        }

        static let elfCalories = Many {
            Int.parser(of: Substring.self)
        } separator: {
            Whitespace(1, .vertical)
        }
        .map { $0.reduce(0, +) }

        static let allElves = Parse {
            Many {
                elfCalories
            } separator: {
                Whitespace(2, .vertical)
            }
            Whitespace(1, .vertical)
            End()
        }
    }
}
