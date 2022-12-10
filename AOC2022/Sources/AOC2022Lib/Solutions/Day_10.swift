import Foundation
import Overture
import Parsing

struct Day10: Solution {
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            with([20, 60, 100, 140, 180, 220], curry(captureCycles)),
            calculateSignalStrength,
            { $0.values.reduce(0, +) },
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }
    
    enum Instruction {
        case noop
        case addx(Int)
    }
    
    func captureCycles(_ cycleCounts: [Int], instructions: [Instruction]) -> [Int: Int] {
        var register: Int = 1
        var cycleCount: Int = 1
        func spinCycles(count: Int, cycleValues: inout [Int: Int], onCompletion: () -> Void) {
            for _ in 0..<count {
                if cycleCounts.contains(cycleCount) {
                    cycleValues[cycleCount] = register
                }
                cycleCount += 1
            }
            onCompletion()
        }
        return instructions.reduce(into: [:]) { values, instruction in
            switch instruction {
            case .noop:
                spinCycles(count: 1, cycleValues: &values, onCompletion: {})
            case let .addx(value):
                spinCycles(count: 2, cycleValues: &values, onCompletion: { register += value })
            }
        }
    }
    
    func calculateSignalStrength(_ cycleValues: [Int: Int]) -> [Int: Int] {
        cycleValues.reduce(into: [:]) { cycleValues, element in
            cycleValues[element.key] = element.key * element.value
        }
    }
    
    enum Parsers {
        static let addx = Parse {
            "addx "
            Int.parser()
        }.map(.case(Instruction.addx))
        
        static let noop = Parse {
            "noop"
        }.map(.case(Instruction.noop))
        
        static let instruction = OneOf {
            addx
            noop
        }
        
        static let input = Many {
            instruction
        } separator: {
            Whitespace(1, .vertical)
        }
    }
}
