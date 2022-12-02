import CustomDump
import XCTest

@testable import AOC2022

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
}
