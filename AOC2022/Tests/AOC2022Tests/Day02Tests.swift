import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day02Tests: XCTestCase {
    let sampleInput = """
    A Y
    B X
    C Z
    """

    func testSampleSolution_PartOne() async throws {
        let answer = try await Day02().runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "15")
    }

    func testSampleSolution_PartTwo() async throws {
        let answer = try await Day02().runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "12")
    }
}
