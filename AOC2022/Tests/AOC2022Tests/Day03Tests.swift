import CustomDump
import XCTest

@testable import AOC2022

final class Day03Tests: XCTestCase {
    let sampleInput = """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """

    func testSampleSolution_PartOne() async throws {
        let answer = try await Day03().runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "157")
    }
    
    func testSampleSolution_PartTwo() async throws {
        let answer = try await Day03().runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "70")
    }
    
    func testFindElfGroups() {
        let rucksacks: [Day03.Rucksack] = [
            (left: ["A", "B", "C"], right: ["D", "E", "F"]),
            (left: ["A", "B", "C"], right: ["D", "E", "F"]),
            (left: ["A", "B", "C"], right: ["D", "E", "F"]),
            (left: ["G", "H", "I"], right: ["D", "E", "F"]),
            (left: ["A", "B", "C"], right: ["D", "E", "F"]),
            (left: ["A", "B", "C"], right: ["D", "E", "F"])
        ]
        
        let groups = Day03().findElfGroups(in: rucksacks)
        
        XCTAssertEqual(2, groups.count)
        XCTAssertEqual(3, groups[0].count)
        XCTAssertEqual(3, groups[1].count)
        
        XCTAssertEqual(["G", "H", "I"], groups[1].first?.left)
    }
    
    func testFindBadges() {
        let solution = Day03()
        let rucksacks = solution.parseInput(sampleInput)
        let groups = solution.findElfGroups(in: rucksacks)
        let badges = solution.findBadges(in: groups)
        
        XCTAssertNoDifference(["r", "Z"], badges)
    }
}
