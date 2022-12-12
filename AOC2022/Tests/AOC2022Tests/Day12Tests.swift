import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day12Tests: XCTestCase {
    let sampleInput = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """
    
    let solution = Day12()
    
    func testParsing() throws {
        let grid = solution.parseInput(sampleInput)
        
        XCTAssertEqual(5, grid.count)
        XCTAssertNoDifference(["S", "a", "b", "q", "p", "o", "n", "m"], grid[0])
    }
    
    func testFindStartAndFinish() {
        let grid = solution.parseInput(sampleInput)
        let coords = solution.findStartAndFinish(in: grid)
        XCTAssertNoDifference(coords.start, .init(x: 0, y: 0))
        XCTAssertNoDifference(coords.finish, .init(x: 5, y: 2))
    }
    
    func testFindShortestPath() {
        let grid = solution.parseInput(sampleInput)
        let shortestPath = solution.findShortestRoute(in: grid)
        XCTAssertEqual(31, shortestPath)
    }
    
    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "31")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
