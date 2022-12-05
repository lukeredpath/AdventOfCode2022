import Foundation
import Parsing

struct Day01: Solution {
    func runPartOne(input: Data) async throws -> String {
        let calories = try Parsers.allElves.parse(utf8String(from: input))
        let sorted = calories.sorted { $0 > $1 }
        return String(sorted.first!)
    }

    func runPartTwo(input: Data) async throws -> String {
        let calories = try Parsers.allElves.parse(utf8String(from: input))
        let topThreeTotal = calories.sorted { $0 > $1 }.prefix(3).reduce(0, +)
        return String(topThreeTotal)
    }

    enum Parsers {
        static let elfCalories = Many {
            Int.parser(of: Substring.self)
        } separator: {
            Whitespace(1, .vertical)
        }
        .map { $0.reduce(0, +) }

        static let allElves = Many {
            elfCalories
        } separator: {
            Whitespace(2, .vertical)
        }
    }
}
