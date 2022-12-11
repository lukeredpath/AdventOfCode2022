import Foundation
import Overture
import Parsing

struct Day11: Solution {
    struct GameState: Equatable {
        var monkeys: [Monkey] = []
        var modulo: Int {
            monkeys.dropFirst().reduce(monkeys[0].test.divisibleBy) {
                $0 * $1.test.divisibleBy
            }
        }
    }
    
    struct Test: Equatable {
        var divisibleBy: Int
        var whenTrue: Int
        var whenFalse: Int
    }
    
    typealias Operation = (Int) -> Int
    
    struct Monkey: Equatable {
        var items: [Int]
        var operation: Operation
        var test: Test
        var inspectionCount: Int = 0
        
        static func == (lhs: Day11.Monkey, rhs: Day11.Monkey) -> Bool {
            lhs.items == rhs.items &&
            lhs.test == rhs.test &&
            lhs.inspectionCount == rhs.inspectionCount &&
            lhs.operation(5) == rhs.operation(5)
        }
        
        mutating func pickUpNextItem() -> Int? {
            guard items.count > 0 else { return nil }
            inspectionCount += 1
            return items.removeFirst()
        }
        
        mutating func catchItem(_ item: Int) {
            items.append(item)
        }
    }
    
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            { String(data: $0, encoding: .utf8)! },
            Parsers.input.parse,
            with(20, curry(runGameOne)),
            calculateMonkeyBusiness,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        try pipe(
            { String(data: $0, encoding: .utf8)! },
            Parsers.input.parse,
            with(10000, curry(runGameTwo)),
            calculateMonkeyBusiness,
            String.init
        )(input)
    }
    
    func runGameOne(rounds: Int, state: GameState) -> GameState {
        (1...rounds).reduce(state) { state, _ in
            runRound(state)
        }
    }
    
    func runRound(_ state: GameState) -> GameState {
        state.monkeys.indices.reduce(into: state) { partialResult, index in
            takeTurn(monkey: index, state: &partialResult)
        }
    }
    
    func takeTurn(monkey index: Int, state: inout GameState) {
        guard state.monkeys.indices.contains(index) else {
            assertionFailure("Monkey does not exist at index \(index)")
            return
        }
        var monkey = state.monkeys[index]
        while var itemWorryLevel = monkey.pickUpNextItem() {
            itemWorryLevel = Int(Double(monkey.operation(itemWorryLevel)) / 3)
            if itemWorryLevel.isMultiple(of: monkey.test.divisibleBy) {
                state.monkeys[monkey.test.whenTrue].catchItem(itemWorryLevel)
            } else {
                state.monkeys[monkey.test.whenFalse].catchItem(itemWorryLevel)
            }
        }
        state.monkeys[index] = monkey
    }
    
    func runGameTwo(rounds: Int, state: GameState) -> GameState {
        (1...rounds).reduce(state) { state, _ in
            runRoundTwo(state)
        }
    }
    
    func runRoundTwo(_ state: GameState) -> GameState {
        state.monkeys.indices.reduce(into: state) { partialResult, index in
            takeTurnTwo(monkey: index, state: &partialResult)
        }
    }
    
    func takeTurnTwo(monkey index: Int, state: inout GameState) {
        guard state.monkeys.indices.contains(index) else {
            assertionFailure("Monkey does not exist at index \(index)")
            return
        }
        var monkey = state.monkeys[index]
        while var itemWorryLevel = monkey.pickUpNextItem() {
            let result = Int(Double(monkey.operation(itemWorryLevel)))
            itemWorryLevel = result % state.modulo
            if itemWorryLevel.isMultiple(of: monkey.test.divisibleBy) {
                state.monkeys[monkey.test.whenTrue].catchItem(itemWorryLevel)
            } else {
                state.monkeys[monkey.test.whenFalse].catchItem(itemWorryLevel)
            }
        }
        state.monkeys[index] = monkey
    }
    
    func calculateMonkeyBusiness(from state: GameState) -> Int {
        let mostActive = state.monkeys.sorted { $0.inspectionCount > $1.inspectionCount }[0..<2]
        return mostActive[0].inspectionCount * mostActive[1].inspectionCount
    }
    
    enum Parsers {
        enum Operator {
            case multiply
            case add
        }
        
        enum Operand {
            case int(Int)
            case old
        }
        
        static let items = Parse {
            Whitespace(2, .horizontal)
            "Starting items: "
            Many { Int.parser() } separator: { ", " }
        }
        
        static let operation = Parse {
            Whitespace(2, .horizontal)
            "Operation: new = old "
            OneOf {
                "*".map(.case(Operator.multiply))
                "+".map(.case(Operator.add))
            }
            " "
            OneOf {
                Int.parser().map(.case(Operand.int))
                "old".map(.case(Operand.old))
            }
        }.map { op, operandType -> (Int) -> Int in
            { oldValue in
                var operand: Int
                switch operandType {
                case let .int(value):
                    operand = value
                case .old:
                    operand = oldValue
                }
                switch op {
                case .multiply:
                    return oldValue * operand
                case .add:
                    return oldValue + operand
                }
            }
        }
        
        static let test = Parse {
            Parse {
                Whitespace(2, .horizontal)
                "Test: divisible by "
                Int.parser()
                Whitespace(1, .vertical)
            }
            Parse {
                Whitespace(4, .horizontal)
                "If true: throw to monkey "
                Int.parser()
                Whitespace(1, .vertical)
            }
            Parse {
                Whitespace(4, .horizontal)
                "If false: throw to monkey "
                Int.parser()
            }
        }.map(.memberwise(Test.init))
        
        static let monkey = Parse {
            Parse {
                "Monkey "
                Skip { Int.parser() }
                ":"
                Whitespace(1, .vertical)
            }
            Parse {
                items
                Whitespace(1, .vertical)
            }
            Parse {
                operation
                Whitespace(1, .vertical)
            }
            test
        }.map { Monkey(items: $0, operation: $1, test: $2) }
        
        static let input = Many {
            monkey
        } separator: {
            Whitespace(2, .vertical)
        } terminator: {
            Whitespace(1, .vertical)
        }
        .map(GameState.init)
    }
}
