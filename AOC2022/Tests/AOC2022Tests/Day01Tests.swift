import CustomDump
import XCTest

@testable import AOC2022

final class Day01Tests: XCTestCase {
    let sampleInput = """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    
    """

    func testParsing() throws {
        let expected = [
            6000,
            4000,
            11_000,
            24_000,
            10_000
        ]
        XCTAssertNoDifference(
            expected,
            try Day01.Parsers.parseInput(sampleInput)
        )
    }

    func testSampleSolution() async throws {
        var output = ""
        let puzzle = Day01(printer: .init(print: {
            output += $0
        }))
        try await puzzle.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(output, "The highest total number of calories is 24000")
    }
}
