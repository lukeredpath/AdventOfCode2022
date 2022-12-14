import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day14Tests: XCTestCase {
    let sampleInput = """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9

    """

    let solution = Day14()

    func testMarkRocks() {
        var map: Day14.NodeMap = [:]

        solution.traceNodes(
            on: &map,
            from: Day14.Point(x: 0, y: 5),
            to: Day14.Point(x: 0, y: 9),
            as: .rock
        )

        XCTAssertNoDifference(map, [
            Day14.Point(x: 0, y: 5): .rock,
            Day14.Point(x: 0, y: 6): .rock,
            Day14.Point(x: 0, y: 7): .rock,
            Day14.Point(x: 0, y: 8): .rock,
            Day14.Point(x: 0, y: 9): .rock
        ])

        solution.traceNodes(
            on: &map,
            from: Day14.Point(x: 0, y: 7),
            to: Day14.Point(x: 3, y: 7),
            as: .rock
        )

        XCTAssertNoDifference(map, [
            Day14.Point(x: 0, y: 5): .rock,
            Day14.Point(x: 0, y: 6): .rock,
            Day14.Point(x: 0, y: 7): .rock,
            Day14.Point(x: 0, y: 8): .rock,
            Day14.Point(x: 0, y: 9): .rock,
            Day14.Point(x: 1, y: 7): .rock,
            Day14.Point(x: 2, y: 7): .rock,
            Day14.Point(x: 3, y: 7): .rock
        ])
    }

    func testTracePaths() {
        var map: Day14.NodeMap = [:]

        map = solution.tracePath([
            Day14.Point(x: 498, y: 4),
            Day14.Point(x: 498, y: 6),
            Day14.Point(x: 496, y: 6)
        ], on: map, as: .rock)

        XCTAssertNoDifference(map, [
            Day14.Point(x: 498, y: 4): .rock,
            Day14.Point(x: 498, y: 5): .rock,
            Day14.Point(x: 498, y: 6): .rock,
            Day14.Point(x: 497, y: 6): .rock,
            Day14.Point(x: 496, y: 6): .rock
        ])
    }

    func testSimulateSand() {
        var map: Day14.NodeMap = [:]

        map = solution.tracePath([
            Day14.Point(x: 498, y: 4),
            Day14.Point(x: 498, y: 6),
            Day14.Point(x: 496, y: 6)
        ], on: map, as: .rock)

        map = solution.tracePath([
            Day14.Point(x: 503, y: 4),
            Day14.Point(x: 502, y: 4),
            Day14.Point(x: 502, y: 9),
            Day14.Point(x: 494, y: 9)
        ], on: map, as: .rock)

        XCTAssertNoDifference(solution.printMap(map), """
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        ........#.
        #########.

        """)

        let startingPoint = Day14.Point(x: 500, y: 0)

        XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertEqual(map[Day14.Point(x: 500, y: 8)], .sand)

        XCTAssertNoDifference(solution.printMap(map), """
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        ......o.#.
        #########.

        """)

        XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertEqual(map[Day14.Point(x: 499, y: 8)], .sand)

        XCTAssertNoDifference(solution.printMap(map), """
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        .....oo.#.
        #########.

        """)

        XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertEqual(map[Day14.Point(x: 501, y: 8)], .sand)

        XCTAssertNoDifference(solution.printMap(map), """
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        .....ooo#.
        #########.

        """)

        // Lets simulate another 19 grains of sand like the example given.
        for x in (0..<19) {
            XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))
        }

        XCTAssertNoDifference(solution.printMap(map), """
        ......o...
        .....ooo..
        ....#ooo##
        ....#ooo#.
        ..###ooo#.
        ....oooo#.
        ...ooooo#.
        #########.

        """)

        XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertNoDifference(solution.printMap(map), """
        ......o...
        .....ooo..
        ....#ooo##
        ...o#ooo#.
        ..###ooo#.
        ....oooo#.
        ...ooooo#.
        #########.

        """)

        XCTAssert(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertNoDifference(solution.printMap(map), """
        ......o...
        .....ooo..
        ....#ooo##
        ...o#ooo#.
        ..###ooo#.
        ....oooo#.
        .o.ooooo#.
        #########.

        """)

        // This grain should fall off the map.
        XCTAssertFalse(solution.simulateSand(on: &map, startingPoint: startingPoint))

        XCTAssertNoDifference(solution.printMap(map), """
        ......o...
        .....ooo..
        ....#ooo##
        ...o#ooo#.
        ..###ooo#.
        ....oooo#.
        .o.ooooo#.
        #########.

        """)
    }

    func testFullSimulation() {
        var map: Day14.NodeMap = [:]

        map = solution.tracePath([
            Day14.Point(x: 498, y: 4),
            Day14.Point(x: 498, y: 6),
            Day14.Point(x: 496, y: 6)
        ], on: map, as: .rock)

        map = solution.tracePath([
            Day14.Point(x: 503, y: 4),
            Day14.Point(x: 502, y: 4),
            Day14.Point(x: 502, y: 9),
            Day14.Point(x: 494, y: 9)
        ], on: map, as: .rock)

        let result = solution.simulateGrains(on: map, startingPoint: .init(x: 500, y: 0))

        XCTAssertEqual(24, result)
    }

    func testParsing() throws {
        let point = try Day14.Parsers.point.parse("142,8")
        XCTAssertNoDifference(point, .init(x: 142, y: 8))

        let path = try Day14.Parsers.path.parse("142,8 -> 142,12 -> 140,12")
        XCTAssertNoDifference(path, [.init(x: 142, y: 8), .init(x: 142, y: 12), .init(x: 140, y: 12)])

        let input = try Day14.Parsers.input.parse(sampleInput.trimmingCharacters(in: .newlines))
        var map: Day14.NodeMap = [:]
        for path in input {
            map = solution.tracePath(path, on: map, as: .rock)
        }

        XCTAssertNoDifference(solution.printMap(map), """
        ....#...##
        ....#...#.
        ..###...#.
        ........#.
        ........#.
        #########.

        """)
    }

    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "24")
    }

    func _testSampleSolution_PartTwo() async throws {
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
