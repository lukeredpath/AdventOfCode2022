import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day13Tests: XCTestCase {
    let sampleInput = """
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]

    """

    let solution = Day13()

    func testCompareInts() {
        XCTAssertEqual(
            solution.compareOrder(left: .int(1), right: .int(2)),
            .correctOrder
        )
        XCTAssertEqual(
            solution.compareOrder(left: .int(2), right: .int(1)),
            .wrongOrder
        )
        XCTAssertEqual(
            solution.compareOrder(left: .int(2), right: .int(2)),
            .next
        )
    }

    func testCompareLists() {
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(1), .int(1), .int(3), .int(1), .int(1)]),
                right: .list([.int(1), .int(1), .int(5), .int(1), .int(1)])
            ),
            .correctOrder
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(1), .int(1), .int(5), .int(1), .int(1)]),
                right: .list([.int(1), .int(1), .int(3), .int(1), .int(1)])
            ),
            .wrongOrder
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(1), .int(1), .int(1), .int(1), .int(1)]),
                right: .list([.int(1), .int(1), .int(1), .int(1), .int(1)])
            ),
            .next
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(1), .int(1), .int(1)]),
                right: .list([.int(1), .int(1), .int(1), .int(1), .int(1)])
            ),
            .correctOrder
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(1), .int(1), .int(1), .int(1), .int(1)]),
                right: .list([.int(1), .int(1), .int(1)])
            ),
            .wrongOrder
        )
    }

    func testCompareNestedLists() {
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.int(9)]),
                right: .list([.list([.int(8), .int(7), .int(6)])])
            ),
            .wrongOrder
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.list([.int(4), .int(4)]), .int(4), .int(4)]),
                right: .list([.list([.int(4), .int(4)]), .int(4), .int(4), .int(4)])
            ),
            .correctOrder
        )
        XCTAssertEqual(
            solution.compareOrder(
                left: .list([.list([.list([])])]),
                right: .list([.list([])])
            ),
            .wrongOrder
        )
    }

    func testParseList() throws {
        XCTAssertNoDifference(
            try Day13.Parsers.list.parse("[1,2,3]"),
            [.int(1), .int(2), .int(3)]
        )
        XCTAssertNoDifference(
            try Day13.Parsers.list.parse("[[1],2,3]"),
            [.list([.int(1)]), .int(2), .int(3)]
        )
        XCTAssertNoDifference(
            try Day13.Parsers.list.parse("[[1],2,[[]]]"),
            [.list([.int(1)]), .int(2), .list([.list([])])]
        )
    }

    func testParsePair() throws {
        let input = """
        [1,1,3,1,1]
        [1,1,5,1,1]
        """

        let pair = try Day13.Parsers.packetPair.parse(input)
        XCTAssertNoDifference(pair.left, [.int(1), .int(1), .int(3), .int(1), .int(1)])
        XCTAssertNoDifference(pair.right, [.int(1), .int(1), .int(5), .int(1), .int(1)])
    }

    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "13")
    }

    func testSampleSolution_PartTwo() async throws {
        // We can also print the ordered packets to help verify the output.
        let pairs = try Day13.Parsers.input.parse(sampleInput.trimmingCharacters(in: .newlines))
        var packets = solution.flattenPacketPairs(pairs)
        packets = solution.appendDividerPackets(to: packets)
        packets = solution.sortPackets(packets)

        let output = try Day13.Parsers.packets.print(packets)
        XCTAssertNoDifference(output, """
        []
        [[]]
        [[[]]]
        [1,1,3,1,1]
        [1,1,5,1,1]
        [[1],[2,3,4]]
        [1,[2,[3,[4,[5,6,0]]]],8,9]
        [1,[2,[3,[4,[5,6,7]]]],8,9]
        [[1],4]
        [[2]]
        [3]
        [[4,4],4,4]
        [[4,4],4,4,4]
        [[6]]
        [7,7,7]
        [7,7,7,7]
        [[8,7,6]]
        [9]
        """)

        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "140")
    }
}
