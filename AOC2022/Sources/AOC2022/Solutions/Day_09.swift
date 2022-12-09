import Foundation
import Overture
import Parsing

struct Day09: Solution {
    private let start = Rope(.init(x: 0, y: 0), .init(x: 0, y: 0))
    
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Day09.Parsers.input.parse,
            with(start, curry(moveMultiple)),
            { $0.tails.count },
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }
    
    struct Position: Hashable {
        var x: Int
        var y: Int
    }
    
    typealias Rope = (head: Position, tail: Position)
    
    enum Movement: Equatable {
        case up(Int)
        case down(Int)
        case left(Int)
        case right(Int)
    }
    
    /// Calculates the new position fro a start position given a movement, returning the new position and all of the unique places
    /// occupied by the tail during the series of movements.
    func move(_ rope: Rope, _ movement: Movement) -> (rope: Rope, tails: Set<Position>) {
        var head = rope.head
        var tail = rope.tail
        var tails: Set<Position> = [rope.tail]
        
        switch movement {
        case let .up(steps):
            for _ in (0..<steps) {
                head.y += 1
                if tail.y < head.y - 1 {
                    tail.y += 1
                    if tail.x != head.x {
                        tail.x = head.x
                    }
                }
                tails.insert(tail)
            }
        case let .down(steps):
            for _ in (0..<steps) {
                head.y -= 1
                // If the tail is on the same col, it just needs to move
                // vertically to keep up.
                if tail.y > head.y + 1 {
                    tail.y -= 1
                    if tail.x != head.x {
                        tail.x = head.x
                    }
                }
                tails.insert(tail)
            }
        case let .left(steps):
            for _ in (0..<steps) {
                head.x -= 1
                // If the tail is on the same row, it just needs to move
                // laterally to keep up.
                if tail.x > head.x + 1 {
                    tail.x -= 1
                    if tail.y != head.y {
                        tail.y = head.y
                    }
                }
                tails.insert(tail)
            }
        case let .right(steps):
            for _ in (0..<steps) {
                head.x += 1
                // If the tail is on the same row, it just needs to move
                // laterally to keep up.
                if tail.x < head.x - 1 {
                    tail.x += 1
                    if tail.y != head.y {
                        tail.y = head.y
                    }
                }
                tails.insert(tail)
            }
        }
        return (rope: (head: head, tail: tail), tails: tails)
    }
    
    func moveMultiple(_ rope: Rope, movements: [Movement]) -> (rope: Rope, tails: Set<Position>) {
        movements.reduce(into: (rope: rope, tails: Set<Position>())) { partialResult, movement in
            let moveResult = move(partialResult.rope, movement)
            partialResult.rope = moveResult.rope
            partialResult.tails.formUnion(moveResult.tails)
        }
    }
    
    enum Parsers {
        static let movement = OneOf {
            Parse {
                "U "
                Int.parser()
            }.map(.case(Movement.up))
            Parse {
                "D "
                Int.parser()
            }.map(.case(Movement.down))
            Parse {
                "L "
                Int.parser()
            }.map(.case(Movement.left))
            Parse {
                "R "
                Int.parser()
            }.map(.case(Movement.right))
        }
        
        static let input = Many {
            movement
        } separator: {
            Whitespace(1, .vertical)
        }
    }
}
