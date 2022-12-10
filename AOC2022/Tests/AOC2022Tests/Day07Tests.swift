import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day07Tests: XCTestCase {
    let sampleInput = """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k

    """

    func testParsing() throws {
        let input = """
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d

        """

        let expected: [Day07.Command] = [
            .cd("/"),
            .ls(output: [
                .dir("a"),
                .file(14848514, "b.txt"),
                .file(8504156, "c.dat"),
                .dir("d")
            ])
        ]

        try XCTAssertNoDifference(Day07.Parsers.input.parse(input), expected)
    }

    func testSampleSolution_PartOne() async throws {
        let solution = Day07()
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "95437")
    }

    func testSampleSolution_PartTwo() async throws {
        let solution = Day07()
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "24933642")
    }
}
