import CustomDump
import XCTest

@testable import AOC2022Lib

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
        let rope = solution.makeRope(knots: 2)
        var result = solution.move(rope, .right(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 0)
        XCTAssertEqual(result.rope.tailPosition.x, 3)
        XCTAssertEqual(result.rope.tailPosition.y, 0)
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 2, y: 0),
            .init(x: 3, y: 0)
        ])
        
        result = solution.move(result.rope, .up(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tailPosition.x, 4)
        XCTAssertEqual(result.rope.tailPosition.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 3, y: 0),
            .init(x: 4, y: 1),
            .init(x: 4, y: 2),
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .left(3))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tailPosition.x, 2)
        XCTAssertEqual(result.rope.tailPosition.y, 4)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3),
            .init(x: 3, y: 4),
            .init(x: 2, y: 4),
        ])
        
        result = solution.move(result.rope, .down(1))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 3)
        XCTAssertEqual(result.rope.tailPosition.x, 2)
        XCTAssertEqual(result.rope.tailPosition.y, 4)
        XCTAssertNoDifference(result.tails, [
            .init(x: 2, y: 4)
        ])
        
        result = solution.move(result.rope, .right(4))
        
        XCTAssertEqual(result.rope.head.x, 5)
        XCTAssertEqual(result.rope.head.y, 3)
        XCTAssertEqual(result.rope.tailPosition.x, 4)
        XCTAssertEqual(result.rope.tailPosition.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 2, y: 4),
            .init(x: 3, y: 3),
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .down(1))
        
        XCTAssertEqual(result.rope.head.x, 5)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tailPosition.x, 4)
        XCTAssertEqual(result.rope.tailPosition.y, 3)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3)
        ])
        
        result = solution.move(result.rope, .left(5))
        
        XCTAssertEqual(result.rope.head.x, 0)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tailPosition.x, 1)
        XCTAssertEqual(result.rope.tailPosition.y, 2)
        XCTAssertNoDifference(result.tails, [
            .init(x: 4, y: 3),
            .init(x: 3, y: 2),
            .init(x: 2, y: 2),
            .init(x: 1, y: 2)
        ])
        
        result = solution.move(result.rope, .right(2))
        
        XCTAssertEqual(result.rope.head.x, 2)
        XCTAssertEqual(result.rope.head.y, 2)
        XCTAssertEqual(result.rope.tailPosition.x, 1)
        XCTAssertEqual(result.rope.tailPosition.y, 2)
        XCTAssertNoDifference(result.tails, [
            .init(x: 1, y: 2)
        ])
    }
    
    func testMultipleMovements() {
        let rope = solution.makeRope(knots: 2)
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
        XCTAssertEqual(result.rope.tailPosition.x, 1)
        XCTAssertEqual(result.rope.tailPosition.y, 2)
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
    
    func testMakeMultiKnotRope() {
        let rope = solution.makeRope(knots: 10)
        let positions = solution.knotPositions(in: rope)

        XCTAssertEqual(10, positions.count)
        XCTAssertNoDifference(positions, [
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0)
        ])
    }
    
    func testMultiKnotMovement() {
        let rope = solution.makeRope(knots: 10)
        var result = solution.move(rope, .right(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 0)
        XCTAssertEqual(result.rope.tailPosition.x, 0)
        XCTAssertEqual(result.rope.tailPosition.y, 0)
        XCTAssertNoDifference(solution.knotPositions(in: result.rope), [
            .init(x: 4, y: 0),
            .init(x: 3, y: 0),
            .init(x: 2, y: 0),
            .init(x: 1, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0)
        ])
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0)
        ])
        
        result = solution.move(result.rope, .up(4))
        
        XCTAssertEqual(result.rope.head.x, 4)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tailPosition.x, 0)
        XCTAssertEqual(result.rope.tailPosition.y, 0)
        XCTAssertNoDifference(solution.knotPositions(in: result.rope), [
            .init(x: 4, y: 4),
            .init(x: 4, y: 3),
            .init(x: 4, y: 2),
            .init(x: 3, y: 2),
            .init(x: 2, y: 2),
            .init(x: 1, y: 1),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0)
        ])
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0)
        ])
        
        result = solution.move(result.rope, .left(3))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 4)
        XCTAssertEqual(result.rope.tailPosition.x, 0)
        XCTAssertEqual(result.rope.tailPosition.y, 0)
        XCTAssertNoDifference(solution.knotPositions(in: result.rope), [
            .init(x: 1, y: 4),
            .init(x: 2, y: 4),
            .init(x: 3, y: 3),
            .init(x: 3, y: 2),
            .init(x: 2, y: 2),
            .init(x: 1, y: 1),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0)
        ])
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0)
        ])
        
        result = solution.move(result.rope, .down(1))
        
        XCTAssertEqual(result.rope.head.x, 1)
        XCTAssertEqual(result.rope.head.y, 3)
        XCTAssertEqual(result.rope.tailPosition.x, 0)
        XCTAssertEqual(result.rope.tailPosition.y, 0)
        XCTAssertNoDifference(solution.knotPositions(in: result.rope), [
            .init(x: 1, y: 3),
            .init(x: 2, y: 4),
            .init(x: 3, y: 3),
            .init(x: 3, y: 2),
            .init(x: 2, y: 2),
            .init(x: 1, y: 1),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0),
            .init(x: 0, y: 0)
        ])
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0)
        ])
    }
    
    func testMultiKnotLargerExample() {
        let rope = solution.makeRope(knots: 10)
        let result = solution.moveMultiple(rope, movements: [
            .right(5),
            .up(8),
            .left(8),
            .down(3),
            .right(17),
            .down(10),
            .left(25),
            .up(20)
        ])
        XCTAssertEqual(result.rope.head.x, -11)
        XCTAssertEqual(result.rope.head.y, 15)
        XCTAssertEqual(result.rope.tailPosition.x, -11)
        XCTAssertEqual(result.rope.tailPosition.y, 6)
        XCTAssertNoDifference(solution.knotPositions(in: result.rope), [
            .init(x: -11, y: 15),
            .init(x: -11, y: 14),
            .init(x: -11, y: 13),
            .init(x: -11, y: 12),
            .init(x: -11, y: 11),
            .init(x: -11, y: 10),
            .init(x: -11, y: 9),
            .init(x: -11, y: 8),
            .init(x: -11, y: 7),
            .init(x: -11, y: 6)
        ])
        XCTAssertEqual(result.tails.count, 36)
        XCTAssertNoDifference(result.tails, [
            .init(x: 0, y: 0),
            .init(x: 1, y: 1),
            .init(x: 2, y: 2),
            .init(x: 1, y: 3),
            .init(x: 2, y: 4),
            .init(x: 3, y: 5),
            .init(x: 4, y: 5),
            .init(x: 5, y: 5),
            .init(x: 6, y: 4),
            .init(x: 7, y: 3),
            .init(x: 8, y: 2),
            .init(x: 9, y: 1),
            .init(x: 10, y: 0),
            .init(x: 9, y: -1),
            .init(x: 8, y: -2),
            .init(x: 7, y: -3),
            .init(x: 6, y: -4),
            .init(x: 5, y: -5),
            .init(x: 4, y: -5),
            .init(x: 3, y: -5),
            .init(x: 2, y: -5),
            .init(x: 1, y: -5),
            .init(x: 0, y: -5),
            .init(x: -1, y: -5),
            .init(x: -2, y: -5),
            .init(x: -3, y: -4),
            .init(x: -4, y: -3),
            .init(x: -5, y: -2),
            .init(x: -6, y: -1),
            .init(x: -7, y: 0),
            .init(x: -8, y: 1),
            .init(x: -9, y: 2),
            .init(x: -10, y: 3),
            .init(x: -11, y: 4),
            .init(x: -11, y: 5),
            .init(x: -11, y: 6)
        ])
    }
    
    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "13")
    }
    
    func testSampleSolution_PartTwo() async throws {
        let sampleInput = """
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
        """
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "36")
    }
}
