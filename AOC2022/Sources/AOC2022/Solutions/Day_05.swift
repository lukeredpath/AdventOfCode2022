import Foundation
import Overture
import Parsing

struct Day05: Solution {
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            { String(data: $0, encoding: .utf8)! },
            Parsers.input.parse,
            applyMovements,
            extractMessage
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }
    
    func applyMovements(_ input: PuzzleInput) -> Stacks {
        input.instructions.reduce(into: input.stacks) { stacks, movement in
            stacks.applyMovement(movement)
        }
    }
    
    func extractMessage(from stacks: Stacks) -> String {
        stacks.stacks.compactMap { $0.last }.joined()
    }
    
    struct Stacks {
        var stacks: [[String]]
        
        init(stacks: [[String]]) {
            self.stacks = stacks
        }
        
        init(rows: [[String?]]) {
            // Find the longest row to determine the number of stack.
            guard let longestRow = rows.sorted(by: { $0.count > $1.count }).first else {
                stacks = []
                return
            }
            stacks = Array<[String]>(repeating: [], count: longestRow.count)
            for row in rows.reversed() {
                for (col, crate) in row.enumerated() {
                    if let crate {
                        stacks[col].append(crate)
                    }
                }
            }
        }
        
        mutating func applyMovement(_ movement: CrateMovement) {
            for _ in 0..<movement.count {
                let popped = stacks[movement.fromStack - 1].removeLast()
                stacks[movement.toStack - 1].append(popped)
            }
        }
    }
    
    struct CrateMovement: Equatable {
        let count: Int
        let fromStack: Int
        let toStack: Int
    }
    
    typealias PuzzleInput = (stacks: Stacks, instructions: [CrateMovement])
    
    enum Parsers {
        static let crate = Parse {
            "["; CharacterSet.uppercaseLetters; "]"
        }
        .map(.string)
        
        static let emptySlot = Parse {
            "   "
        }.map(.case(Optional<String>.none))
        
        static let crateRow = Many {
            OneOf {
                crate.map { Optional<String>.some($0) }
                emptySlot
            }
        } separator: {
            " "
        }
        
        static let crateNumbers = Many {
            " "
            Int.parser()
            Whitespace(...1, .horizontal)
        } separator: {
            " "
        }
        
        static let crateMovement = Parse {
            "move "
            Int.parser()
            " from "
            Int.parser()
            " to "
            Int.parser()
        }
        .map(CrateMovement.init)
        
        static let instructions = Many {
            crateMovement
        } separator: {
            Whitespace(1, .vertical)
        } terminator: {
            Whitespace(1, .vertical)
        }
        
        static let input = Parse {
            Many { crateRow } separator: {
                Whitespace(1, .vertical)
            }
            .map(Stacks.init(rows:))
            Skip { crateNumbers }
            Whitespace(2, .vertical)
            instructions
        }.map { PuzzleInput(stacks: $0, instructions: $1) }
    }
}
