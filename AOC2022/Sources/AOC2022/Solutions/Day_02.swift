import Foundation
import Parsing

struct Day02: Solution {
    func runPartOne(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        let rounds = try Parsers.roundsPartOne.parse(Substring(inputString))
        let scores = rounds.map(calculateRoundScore)
        return String(scores.reduce(0, +))
    }

    func runPartTwo(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        let rounds = try Parsers.roundsPartTwo.parse(Substring(inputString))
        let scores = rounds.map(calculateRoundScore)
        return String(scores.reduce(0, +))
    }

    enum Shape: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
    }

    enum DesiredResult: Int {
        case win = 6
        case loss = 0
        case draw = 3
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

    func calculateRoundScore(opponent: Shape, desiredResult: DesiredResult) -> Int {
        switch (opponent, desiredResult) {
        case (.rock, .win), (.scissors, .loss):
            return desiredResult.rawValue + Shape.paper.rawValue
        case (.paper, .win), (.rock, .loss):
            return desiredResult.rawValue + Shape.scissors.rawValue
        case (.scissors, .win), (.paper, .loss):
            return desiredResult.rawValue + Shape.rock.rawValue
        case (_, .draw):
            return desiredResult.rawValue + opponent.rawValue
        }
    }

    enum Parsers {
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

        static let desiredResult = OneOf {
            "X".map(.case(DesiredResult.loss))
            "Y".map(.case(DesiredResult.draw))
            "Z".map(.case(DesiredResult.win))
        }

        static let roundsPartOne = Parse {
            Many {
                opponent; " "; response
            } separator: {
                Whitespace(1, .vertical)
            }
            Whitespace(1, .vertical)
            End()
        }

        static let roundsPartTwo = Parse {
            Many {
                opponent; " "; desiredResult
            } separator: {
                Whitespace(1, .vertical)
            }
            Whitespace(1, .vertical)
            End()
        }
    }
}
