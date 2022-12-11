import CustomDump
import XCTest

@testable import AOC2022Lib

final class DayXXTests: XCTestCase {
    let sampleInput = """
    """
    
    let solution = DayXX()
    
    func _testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
