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
            try Day01.Parsers.allElves.parse(sampleInput)
        )
    }

    func testSampleSolution_PartOne() async throws {
        let answer = try await Day01().runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "24000")
    }

    func testSampleSolution_PartTwo() async throws {
        let answer = try await Day01().runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "45000")
    }
}
