import CustomDump
import XCTest

@testable import AOC2022

final class Day06Tests: XCTestCase {
    let sampleInput = """
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
    """

    func testSampleSolution_PartOne() async throws {
        let solution = Day06()
        var answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "7")

        answer = try await solution.runPartOne(input: "bvwbjplbgvbhsrlpgdmjqwftvncz".data(using: .utf8)!)
        XCTAssertEqual(answer, "5")

        answer = try await solution.runPartOne(input: "nppdvjthqldpwncqszvftbrmjlhg".data(using: .utf8)!)
        XCTAssertEqual(answer, "6")

        answer = try await solution.runPartOne(input: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".data(using: .utf8)!)
        XCTAssertEqual(answer, "10")

        answer = try await solution.runPartOne(input: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".data(using: .utf8)!)
        XCTAssertEqual(answer, "11")

        answer = try await solution.runPartOne(input: "aaaabcd".data(using: .utf8)!)
        XCTAssertEqual(answer, "7")
    }

    func testSampleSolution_PartTwo() async throws {
        let solution = Day06()

        var answer = try await solution.runPartTwo(input: "mjqjpqmgbljsphdztnvjfqwrcgsmlb".data(using: .utf8)!)
        XCTAssertEqual(answer, "19")

        answer = try await solution.runPartTwo(input: "bvwbjplbgvbhsrlpgdmjqwftvncz".data(using: .utf8)!)
        XCTAssertEqual(answer, "23")

        answer = try await solution.runPartTwo(input: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".data(using: .utf8)!)
        XCTAssertEqual(answer, "29")

        answer = try await solution.runPartTwo(input: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".data(using: .utf8)!)
        XCTAssertEqual(answer, "26")
    }
}
