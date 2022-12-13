import Foundation
import Overture
import Parsing

struct Day13: Solution {
    typealias Packet = [Value]
    typealias PacketPair = (left: Packet, right: Packet)

    indirect enum Value: Equatable {
        case int(Int)
        case list([Value])
    }

    enum ComparisonResult {
        case correctOrder
        case wrongOrder
        case next
    }

    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            findIndicesForMatchingPackets,
            { $0.reduce(0, +) },
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }

    func findIndicesForMatchingPackets(in pairs: [PacketPair]) -> [Int] {
        pairs.indices.reduce(into: []) { indices, index in
            let pair = pairs[index]
            if comparePackets(left: pair.left, right: pair.right) {
                // Pair indices are 1-based so we should adjust.
                indices.append(index + 1)
            }
        }
    }

    func comparePackets(left: Packet, right: Packet) -> Bool {
        compareOrder(left: .list(left), right: .list(right)) == .correctOrder
    }

    func compareOrder(left: Value, right: Value) -> ComparisonResult {
        switch (left, right) {
        case let (.int(leftValue), .int(rightValue)):
            return compareInts(left: leftValue, right: rightValue)
        case let (.list(leftValue), .list(rightValue)):
            return compareLists(left: leftValue, right: rightValue)
        case let (.list(leftValue), .int):
            return compareLists(left: leftValue, right: [right])
        case let (.int, .list(rightValue)):
            return compareLists(left: [left], right: rightValue)
        }
    }

    private func compareInts(left: Int, right: Int) -> ComparisonResult {
        if left == right { return .next }
        return (left < right) ? .correctOrder : .wrongOrder
    }

    private func compareLists(left: [Value], right: [Value]) -> ComparisonResult {
        let upperBound = max(left.indices.upperBound, right.indices.upperBound)
        for index in 0..<upperBound {
            guard left.indices.contains(index) else {
                // We have run out of left items so the order is correct.
                return .correctOrder
            }
            guard right.indices.contains(index) else {
                // If we have run out of right items before left items the order is wrong.
                return .wrongOrder
            }
            let result = compareOrder(left: left[index], right: right[index])
            if result != .next { return result }
        }
        return .next
    }

    enum Parsers {
        static var value: AnyParser<Substring, Value> {
            OneOf {
                Int.parser().map(Value.int)
                Lazy { list.map(Value.list) }
            }
            .eraseToAnyParser()
        }

        static var list: AnyParser<Substring, [Value]> {
            Parse {
                "["
                Many { value } separator: { "," }
                "]"
            }
            .eraseToAnyParser()
        }

        static let packetPair = Parse {
            list
            Whitespace(1, .vertical)
            list
        }.map { (left: $0, right: $1) }

        static let input = Many {
            packetPair
        } separator: {
            Whitespace(2, .vertical)
        }
    }
}
