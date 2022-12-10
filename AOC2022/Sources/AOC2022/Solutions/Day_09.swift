import Foundation
import Overture
import Parsing

struct Day09: Solution {
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Day09.Parsers.input.parse,
            with(makeRope(knots: 2), curry(moveMultiple)),
            { $0.tails.count },
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Day09.Parsers.input.parse,
            with(makeRope(knots: 10), curry(moveMultiple)),
            { $0.tails.count },
            String.init
        )(input)
    }
    
    struct Position: Hashable {
        var x: Int
        var y: Int
    }
    
    struct Rope: Equatable {
        var head: Position
        var tail: Tail
        var tailPosition: Position {
            switch tail {
            case let .rope(rope):
                return rope.tailPosition
            case let .tail(tail):
                return tail
            }
        }
        // A rope with multiple knots can consist of multiple embedded ropes
        // until it reaches the final knot, represented as the tail case.
        indirect enum Tail: Equatable {
            case tail(Position)
            case rope(Rope)
        }
    }
    
    enum Movement: Equatable {
        case up(Int)
        case down(Int)
        case left(Int)
        case right(Int)
    }
    
    func makeRope(knots: Int) -> Rope {
        // Start with the tail end and work towards the head.
        var rope = Rope(head: .init(x: 0, y: 0), tail: .tail(.init(x: 0, y: 0)))
        for _ in 0..<knots-2 {
            rope = .init(head: .init(x: 0, y: 0), tail: .rope(rope))
        }
        return rope
    }
    
    func move(_ rope: Rope, _ movement: Movement) -> (rope: Rope, tails: Set<Position>) {
        var rope = rope
        var tails: Set<Position> = []
        switch movement {
        case let .up(steps):
            for _ in (0..<steps) {
                movementStep(&rope, tailPositions: &tails, headMovement: { $0.y += 1 })
            }
        case let .down(steps):
            for _ in (0..<steps) {
                movementStep(&rope, tailPositions: &tails, headMovement: { $0.y -= 1 })
            }
        case let .left(steps):
            for _ in (0..<steps) {
                movementStep(&rope, tailPositions: &tails, headMovement: { $0.x -= 1 })
            }
        case let .right(steps):
            for _ in (0..<steps) {
                movementStep(&rope, tailPositions: &tails, headMovement: { $0.x += 1 })
            }
        }
        return (rope: rope, tails: tails)
    }
    
    private func movementStep(
        _ rope: inout Rope,
        tailPositions: inout Set<Position>,
        headMovement: (inout Position) -> Void
    ) {
        headMovement(&rope.head)
        switch rope.tail {
        case var .rope(tailRope):
            adjustTail(&tailRope.head, relativeTo: rope.head)
            // We pass in a no-op head movement as we have already adjusted the tail head.
            movementStep(&tailRope, tailPositions: &tailPositions, headMovement: { _ in })
            rope.tail = .rope(tailRope)
        case var .tail(position):
            adjustTail(&position, relativeTo: rope.head)
            rope.tail = .tail(position)
            tailPositions.insert(position)
        }
    }
    
    private func adjustTail(_ position: inout Position, relativeTo otherPosition: Position) {
        if position.y == otherPosition.y {
            // They are at the same position vertically, adjust horizontally.
            if position.x < otherPosition.x - 1 {
                position.x = otherPosition.x - 1
            } else if position.x > otherPosition.x + 1 {
                position.x = otherPosition.x + 1
            }
        } else if position.x == otherPosition.x {
            // They are at the same position horizontally, adjust vertically.
            if position.y < otherPosition.y - 1 {
                position.y = otherPosition.y - 1
            } else if position.y > otherPosition.y + 1 {
                position.y = otherPosition.y + 1
            }
        } else if (
            position.x == otherPosition.x - 2 && position.y == otherPosition.y - 1 ||
            position.x == otherPosition.x - 1 && position.y == otherPosition.y - 2 ||
            position.x == otherPosition.x - 2 && position.y == otherPosition.y - 2
        ) {
            // tail needs to move up/right
            position.x += 1
            position.y += 1
        } else if (
            position.x == otherPosition.x - 2 && position.y == otherPosition.y + 1 ||
            position.x == otherPosition.x - 1 && position.y == otherPosition.y + 2 ||
            position.x == otherPosition.x - 2 && position.y == otherPosition.y + 2
        ) {
            // tail needs to move down/right
            position.x += 1
            position.y -= 1
        } else if (
            position.x == otherPosition.x + 2 && position.y == otherPosition.y - 1 ||
            position.x == otherPosition.x + 1 && position.y == otherPosition.y - 2 ||
            position.x == otherPosition.x + 2 && position.y == otherPosition.y - 2
        ) {
            // tail needs to move up/left
            position.x -= 1
            position.y += 1
        } else if (
            position.x == otherPosition.x + 2 && position.y == otherPosition.y + 1 ||
            position.x == otherPosition.x + 1 && position.y == otherPosition.y + 2 ||
            position.x == otherPosition.x + 2 && position.y == otherPosition.y + 2
        ) {
            // tail needs to move down/left
            position.x -= 1
            position.y -= 1
        }
    }
    
    func moveMultiple(_ rope: Rope, movements: [Movement]) -> (rope: Rope, tails: Set<Position>) {
        movements.reduce(into: (rope: rope, tails: Set<Position>())) { partialResult, movement in
            let moveResult = move(partialResult.rope, movement)
            partialResult.rope = moveResult.rope
            partialResult.tails.formUnion(moveResult.tails)
        }
    }
    
    func knotPositions(in rope: Rope) -> [Position] {
        var positions: [Position] = [rope.head]
        switch rope.tail {
        case let .rope(rope):
            positions.append(contentsOf: knotPositions(in: rope))
        case let .tail(position):
            positions.append(position)
        }
        return positions
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
