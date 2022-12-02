import Foundation
import Parsing

struct Day02: Solution {
    func runPartOne(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        let rounds = try Parsers.parseInput(inputString)
        let scores = rounds.map(calculateRoundScore)
        return String(scores.reduce(0, +))
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }

    enum Shape: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
    }

    func calculateRoundScore(opponent: Shape, response: Shape) -> Int {
        switch (opponent, response) {
        case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
            return response.rawValue + 3
        case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
            return response.rawValue + 6
        default:
            return response.rawValue
        }
    }

    enum Parsers {
        static func parseInput(_ input: String) throws -> [(Shape, Shape)] {
            try rounds.parse(Substring(input))
        }

        static let opponent = OneOf {
            "A".map(.case(Shape.rock))
            "B".map(.case(Shape.paper))
            "C".map(.case(Shape.scissors))
        }

        static let response = OneOf {
            "X".map(.case(Shape.rock))
            "Y".map(.case(Shape.paper))
            "Z".map(.case(Shape.scissors))
        }

        static let rounds = Parse {
            Many {
                opponent; " "; response
            } separator: {
                Whitespace(1, .vertical)
            }
            Whitespace(1, .vertical)
            End()
        }
    }
}
