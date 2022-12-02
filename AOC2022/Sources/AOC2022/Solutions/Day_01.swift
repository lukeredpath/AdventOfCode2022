import Foundation
import Parsing

struct Day01: Solution {
    var printer: Printer

    init(printer: Printer) {
        self.printer = printer
    }

    func runPartOne(input: Data) async throws {
        let input = String(data: input, encoding: .utf8)!
        let calories = try Parsers.parseInput(input)
        let sorted = calories.sorted { $0 > $1 }
        printer.print("The highest total number of calories is \(sorted.first!)")
    }

    func runPartTwo(input: Data) async throws {
        notImplemented()
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
