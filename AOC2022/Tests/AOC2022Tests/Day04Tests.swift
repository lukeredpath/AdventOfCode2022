import CustomDump
import XCTest

@testable import AOC2022

final class Day04Tests: XCTestCase {
    let sampleInput = """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
    
    func testCountOverlaps() {
        let solution = Day04()
        XCTAssertEqual(0, solution.countOverlappingAssignments(
            in: [(2...4, 6...8)]
        ))
        XCTAssertEqual(1, solution.countOverlappingAssignments(
            in: [(5...8, 7...9)]
        ))
        XCTAssertEqual(1, solution.countOverlappingAssignments(
            in: [(5...9, 6...8)]
        ))
        XCTAssertEqual(1, solution.countOverlappingAssignments(
            in: [(6...6, 4...6)]
        ))
    }
    
    func testCountFullyContained() {
        let solution = Day04()
        XCTAssertEqual(0, solution.countFullyContainedAssignments(
            in: [(2...4, 6...8)]
        ))
        XCTAssertEqual(0, solution.countFullyContainedAssignments(
            in: [(5...8, 7...9)]
        ))
        XCTAssertEqual(1, solution.countFullyContainedAssignments(
            in: [(5...9, 6...8)]
        ))
        XCTAssertEqual(1, solution.countFullyContainedAssignments(
            in: [(5...9, 2...11)]
        ))
    }
    
    func testSampleSolution_PartOne() async throws {
        let solution = Day04()
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "2")
    }
    
    func testSampleSolution_PartTwo() async throws {
        let solution = Day04()
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "4")
    }
}
