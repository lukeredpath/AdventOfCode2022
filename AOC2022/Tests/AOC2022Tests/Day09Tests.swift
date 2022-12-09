import CustomDump
import XCTest

@testable import AOC2022

final class Day09Tests: XCTestCase {
    let sampleInput = """
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    
    """
    
    private let solution = Day09()
    
    func testMovements() {
        let rope = Day09.Rope(head: .init(x: 0, y: 0), tail: .init(x: 0, y: 0))
        var result = solution.move(rope, .right(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 0)
        XCTAssertEqual(result.rope.tail.x, 3)
        XCTAssertEqual(result.rope.tail.y, 0)
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 2, y: 0),
            .init(x: 3, y: 0)
        ])
        
        result = solution.move(result.rope, .up(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tail.x, 4)
        XCTAssertEqual(result.rope.tail.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 3, y: 0),
            .init(x: 4, y: 1),
            .init(x: 4, y: 2),
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .left(3))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tail.x, 2)
        XCTAssertEqual(result.rope.tail.y, 4)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3),
            .init(x: 3, y: 4),
            .init(x: 2, y: 4),
        ])
        
        result = solution.move(result.rope, .down(1))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 3)
        XCTAssertEqual(result.rope.tail.x, 2)
        XCTAssertEqual(result.rope.tail.y, 4)
        XCTAssertNoDifference(result.tails, [
            .init(x: 2, y: 4)
        ])
        
        result = solution.move(result.rope, .right(4))
        
        XCTAssertEqual(result.rope.head.x, 5)
        XCTAssertEqual(result.rope.head.y, 3)
        XCTAssertEqual(result.rope.tail.x, 4)
        XCTAssertEqual(result.rope.tail.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 2, y: 4),
            .init(x: 3, y: 3),
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .down(1))
        
        XCTAssertEqual(result.rope.head.x, 5)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tail.x, 4)
        XCTAssertEqual(result.rope.tail.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .left(5))
        
        XCTAssertEqual(result.rope.head.x, 0)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tail.x, 1)
        XCTAssertEqual(result.rope.tail.y, 2)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3),
            .init(x: 3, y: 2),
            .init(x: 2, y: 2),
            .init(x: 1, y: 2)
        ])
        
        result = solution.move(result.rope, .right(2))
        
        XCTAssertEqual(result.rope.head.x, 2)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tail.x, 1)
        XCTAssertEqual(result.rope.tail.y, 2)
        XCTAssertNoDifference(result.tails, [
            .init(x: 1, y: 2)
        ])
    }
    
    func testMultipleMovements() {
        let rope = Day09.Rope(head: .init(x: 0, y: 0), tail: .init(x: 0, y: 0))
        let result = solution.moveMultiple(rope, movements: [
            .right(4),
            .up(4),
            .left(3),
            .down(1),
            .right(4),
            .down(1),
            .left(5),
            .right(2)
        ])
        XCTAssertEqual(result.rope.head.x, 2)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tail.x, 1)
        XCTAssertEqual(result.rope.tail.y, 2)
        XCTAssertEqual(13, result.tails.count)
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 2, y: 0),
            .init(x: 3, y: 0),
            .init(x: 4, y: 1),
            .init(x: 1, y: 2),
            .init(x: 2, y: 2),
            .init(x: 3, y: 2),
            .init(x: 4, y: 2),
            .init(x: 3, y: 3),
            .init(x: 4, y: 3),
            .init(x: 2, y: 4),
            .init(x: 3, y: 4)
        ])
    }
    
    func testParsing() throws {
        let sampleInput = """
        R 4
        U 3
        D 2
        L 5
        R 1
        """
        
        let expected: [Day09.Movement] = [
            .right(4),
            .up(3),
            .down(2),
            .left(5),
            .right(1)
        ]
        
        try XCTAssertEqual(Day09.Parsers.movement.parse("U 3"), .up(3))
        try XCTAssertEqual(Day09.Parsers.movement.parse("D 2"), .down(2))
        try XCTAssertEqual(Day09.Parsers.movement.parse("L 1"), .left(1))
        try XCTAssertEqual(Day09.Parsers.movement.parse("R 5"), .right(5))
        
        try XCTAssertNoDifference(expected, Day09.Parsers.input.parse(sampleInput))
    }
    
    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "13")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
