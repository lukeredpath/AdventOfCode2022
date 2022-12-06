import CustomDump
import XCTest

@testable import AOC2022

final class Day05Tests: XCTestCase {
    let sampleInput = """
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    
    """
    
    func testParsingRow() async throws {
        XCTAssertEqual("A", try Day05.Parsers.crate.parse("[A]"))
        XCTAssertEqual(nil, try Day05.Parsers.emptySlot.parse("   "))
        
        var row = try Day05.Parsers.crateRow.parse("[Z] [M] [P]")
        XCTAssertEqual(row, ["Z", "M", "P"])
        
        row = try Day05.Parsers.crateRow.parse("[Z]     [P]")
        XCTAssertEqual(row, ["Z", nil, "P"])
        
        row = try Day05.Parsers.crateRow.parse("    [M] [P]")
        XCTAssertEqual(row, [nil, "M", "P"])
        
        row = try Day05.Parsers.crateRow.parse("[Z] [M]    ")
        XCTAssertEqual(row, ["Z", "M", nil])
    }
    
    func testParsingNumbers() async throws {
        XCTAssertEqual([1, 2, 3], try Day05.Parsers.crateNumbers.parse(" 1   2   3"))
        XCTAssertEqual([1, 2, 3], try Day05.Parsers.crateNumbers.parse(" 1   2   3 "))
    }
    
    func testParsingMovement() async throws {
        let movement = try Day05.Parsers.crateMovement.parse("move 1 from 2 to 4")
        XCTAssertEqual(1, movement.count)
        XCTAssertEqual(2, movement.fromStack)
        XCTAssertEqual(4, movement.toStack)
    }
    
    func testParsingSampleInput() async throws {
        let puzzleInput = try Day05.Parsers.input.parse(sampleInput)
        XCTAssertEqual(["Z", "N"], puzzleInput.stacks.stacks[0])
        XCTAssertEqual(["M", "C", "D"], puzzleInput.stacks.stacks[1])
        XCTAssertEqual(["P"], puzzleInput.stacks.stacks[2])
        
        XCTAssertEqual(4, puzzleInput.instructions.count)
        XCTAssertNoDifference(puzzleInput.instructions[0], .init(count: 1, fromStack: 2, toStack: 1))
        XCTAssertNoDifference(puzzleInput.instructions[1], .init(count: 3, fromStack: 1, toStack: 3))
    }
    
    func testMovement() {
        var stacks = Day05.Stacks(stacks: [
            ["A"],
            ["B", "C"],
            ["D", "E", "F"],
            ["G"]
        ])
        
        stacks.applyMovementSingularCrates(.init(count: 1, fromStack: 2, toStack: 3))
        
        XCTAssertNoDifference(stacks.stacks, [
            ["A"],
            ["B"],
            ["D", "E", "F", "C"],
            ["G"]
        ])
        
        stacks.applyMovementSingularCrates(.init(count: 2, fromStack: 3, toStack: 1))
        
        XCTAssertNoDifference(stacks.stacks, [
            ["A", "C", "F"],
            ["B"],
            ["D", "E"],
            ["G"]
        ])
        
        stacks.applyMovementMultipleCrates(.init(count: 2, fromStack: 1, toStack: 4))
        
        XCTAssertNoDifference(stacks.stacks, [
            ["A"],
            ["B"],
            ["D", "E"],
            ["G", "C", "F"]
        ])
    }
    
    func testSampleSolution_PartOne() async throws {
        let solution = Day05()
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "CMZ")
    }
    
    func testSampleSolution_PartTwo() async throws {
        let solution = Day05()
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "MCD")
    }
}
