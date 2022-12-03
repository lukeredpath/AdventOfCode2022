import CustomDump
import XCTest

@testable import AOC2022

final class Day03Tests: XCTestCase {
    let sampleInput = """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """

    func testSampleSolution_PartOne() async throws {
        let answer = try await Day03().runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "157")
    }
}
