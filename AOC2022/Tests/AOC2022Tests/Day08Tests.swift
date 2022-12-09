import CustomDump
import XCTest

@testable import AOC2022

final class Day08Tests: XCTestCase {
    let sampleInput = """
    30373
    25512
    65332
    33549
    35390
    
    """
    
    func testGridBasics() {
        let grid = Day08.Grid(rows: [
            [3, 0, 3, 7, 3],
            [2, 5, 5, 1, 2],
            [6, 5, 3, 3, 2],
            [3, 3, 5, 4, 9],
            [3, 5, 3, 9, 0]
        ])
        
        // Test perimeter trees
        XCTAssertTrue(grid.isVisible(atRow: 0, col: 0))
        XCTAssertTrue(grid.isVisible(atRow: 0, col: 3))
        XCTAssertTrue(grid.isVisible(atRow: 2, col: 0))
        XCTAssertTrue(grid.isVisible(atRow: 3, col: 4))
        XCTAssertTrue(grid.isVisible(atRow: 4, col: 0))
        XCTAssertTrue(grid.isVisible(atRow: 4, col: 4))
        
        // Test visible from left and top
        XCTAssertTrue(grid.isVisible(atRow: 1, col: 1))
        
        // Test visible from right and top
        XCTAssertTrue(grid.isVisible(atRow: 2, col: 1))
        
        // Test visible from bottom
        XCTAssertTrue(grid.isVisible(atRow: 3, col: 2))
        
        // Test not visible
        XCTAssertFalse(grid.isVisible(atRow: 1, col: 3))
        XCTAssertFalse(grid.isVisible(atRow: 2, col: 2))
        
        // Test total visible
        XCTAssertEqual(21, Day08().countVisible(in: grid))
    }
    
    func testParsing() throws {
        let expected = Day08.Grid(rows: [
            [3, 0, 3, 7, 3],
            [2, 5, 5, 1, 2],
            [6, 5, 3, 3, 2],
            [3, 3, 5, 4, 9],
            [3, 5, 3, 9, 0]
        ])
        XCTAssertNoDifference(expected, Day08().parseInput(sampleInput))
    }
    
    func testSampleSolution_PartOne() async throws {
        let solution = Day08()
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "21")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let solution = Day08()
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
