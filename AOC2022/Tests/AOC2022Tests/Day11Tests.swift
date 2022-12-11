import CustomDump
import XCTest
import Parsing

@testable import AOC2022Lib

final class Day11Tests: XCTestCase {
    let sampleInput = """
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1

    """
    
    let solution = Day11()
    
    func testSingleTurn() {
        var state = Day11.GameState(monkeys: [
            .init(items: [3, 5, 9], operation: { $0 * 2 }, test: .init(divisibleBy: 2, whenTrue: 1, whenFalse: 2)),
            .init(items: [5, 8, 1], operation: { $0 * 3 }, test: .init(divisibleBy: 3, whenTrue: 0, whenFalse: 2)),
            .init(items: [2, 2, 4], operation: { $0 + 2 }, test: .init(divisibleBy: 2, whenTrue: 1, whenFalse: 0))
        ])
        
        solution.takeTurn(monkey: 0, state: &state, worryAdjustment: { Int($0 / 3) })
        
        XCTAssertNoDifference(state.monkeys[0].items, [])
        XCTAssertNoDifference(state.monkeys[1].items, [5, 8, 1, 2, 6])
        XCTAssertNoDifference(state.monkeys[2].items, [2, 2, 4, 3])
    }
    
    func testExampleRound() {
        var state = Day11.GameState(monkeys: [
            .init(
                items: [79, 98],
                operation: { $0 * 19 },
                test: .init(divisibleBy: 23, whenTrue: 2, whenFalse: 3)
            ),
            .init(
                items: [54, 65, 75, 74],
                operation: { $0 + 6 },
                test: .init(divisibleBy: 19, whenTrue: 2, whenFalse: 0)),
            .init(
                items: [79, 60, 97],
                operation: { $0 * $0 },
                test: .init(divisibleBy: 13, whenTrue: 1, whenFalse: 3)
            ),
            .init(
                items: [74],
                operation: { $0 + 3 },
                test: .init(divisibleBy: 17, whenTrue: 0, whenFalse: 1)
            )
        ])
        
        state = solution.runRound(state)
        
        XCTAssertNoDifference(state.monkeys[0].items, [20, 23, 27, 26])
        XCTAssertNoDifference(state.monkeys[1].items, [2080, 25, 167, 207, 401, 1046])
        XCTAssertNoDifference(state.monkeys[2].items, [])
        XCTAssertNoDifference(state.monkeys[3].items, [])
        
        // Test many more rounds
        for _ in 1...19 {
            state = solution.runRound(state)
        }
        
        XCTAssertNoDifference(state.monkeys[0].items, [10, 12, 14, 26, 34])
        XCTAssertNoDifference(state.monkeys[1].items, [245, 93, 53, 199, 115])
        XCTAssertNoDifference(state.monkeys[2].items, [])
        XCTAssertNoDifference(state.monkeys[3].items, [])
        
        XCTAssertEqual(state.monkeys[0].inspectionCount, 101)
        XCTAssertEqual(state.monkeys[1].inspectionCount, 95)
        XCTAssertEqual(state.monkeys[2].inspectionCount, 7)
        XCTAssertEqual(state.monkeys[3].inspectionCount, 105)
        XCTAssertEqual(solution.calculateMonkeyBusiness(from: state), 10605)
    }
    
    func testParseOperation() throws {
        let opOne = try Day11.Parsers.operation.parse("  Operation: new = old * 19")
        XCTAssertEqual(190, opOne(10))
        
        let opTwo = try Day11.Parsers.operation.parse("  Operation: new = old * old")
        XCTAssertEqual(100, opTwo(10))
    }
    
    func testParseTest() throws {
        let testInput = """
          Test: divisible by 13
            If true: throw to monkey 1
            If false: throw to monkey 3
        """
        
        let test = try Day11.Parsers.test.parse(testInput)
        XCTAssertEqual(13, test.divisibleBy)
        XCTAssertEqual(1, test.whenTrue)
        XCTAssertEqual(3, test.whenFalse)
    }
    
    func testParsingMonkeys() throws {
        let singleMonkeyInput = """
        Monkey 0:
          Starting items: 79, 98
          Operation: new = old * 19
          Test: divisible by 23
            If true: throw to monkey 2
            If false: throw to monkey 3
        """
        
        let monkey = try Day11.Parsers.monkey.parse(singleMonkeyInput)
        XCTAssertNoDifference(monkey.items, [79, 98])
        XCTAssertNoDifference(monkey.operation(10), 190)
        XCTAssertNoDifference(monkey.test.divisibleBy, 23)
        XCTAssertNoDifference(monkey.test.whenTrue, 2)
        XCTAssertNoDifference(monkey.test.whenFalse, 3)
        
        let expected = Day11.GameState(monkeys: [
            .init(
                items: [79, 98],
                operation: { $0 * 19 },
                test: .init(divisibleBy: 23, whenTrue: 2, whenFalse: 3)
            ),
            .init(
                items: [54, 65, 75, 74],
                operation: { $0 + 6 },
                test: .init(divisibleBy: 19, whenTrue: 2, whenFalse: 0)),
            .init(
                items: [79, 60, 97],
                operation: { $0 * $0 },
                test: .init(divisibleBy: 13, whenTrue: 1, whenFalse: 3)
            ),
            .init(
                items: [74],
                operation: { $0 + 3 },
                test: .init(divisibleBy: 17, whenTrue: 0, whenFalse: 1)
            )
        ])
        
        let result = try Day11.Parsers.input.parse(sampleInput)
        
        XCTAssertNoDifference(result, expected)
    }
    
    func testWorriedGame() throws {
        var state = try Day11.Parsers.input.parse(sampleInput)
        state = solution.runGameTwo(rounds: 10000, state: state)
        
        XCTAssertEqual(state.monkeys[0].inspectionCount, 52166)
        XCTAssertEqual(state.monkeys[1].inspectionCount, 47830)
        XCTAssertEqual(state.monkeys[2].inspectionCount, 1938)
        XCTAssertEqual(state.monkeys[3].inspectionCount, 52013)
        XCTAssertEqual(solution.calculateMonkeyBusiness(from: state), 2713310158)
    }
    
    func testSampleSolution_PartOne() async throws {
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "10605")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
