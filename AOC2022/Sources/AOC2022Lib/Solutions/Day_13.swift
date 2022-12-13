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

    let dividerPacketOne: Value = .list([.int(2)])
    let dividerPacketTwo: Value = .list([.int(6)])

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
        try pipe(
            utf8String,
            pipe(
                Parsers.input.parse,
                flattenPacketPairs,
                appendDividerPackets
            ),
            sortPackets,
            determineDecoderKey,
            String.init
        )(input)
    }

    func flattenPacketPairs(_ pairs: [PacketPair]) -> [Packet] {
        pairs.reduce(into: []) { packets, pair in
            packets.append(pair.left)
            packets.append(pair.right)
        }
    }

    func appendDividerPackets(to packets: [Packet]) -> [Packet] {
        var packets = packets
        packets.append(contentsOf: [[dividerPacketOne], [dividerPacketTwo]])
        return packets
    }

    func sortPackets(_ packets: [Packet]) -> [Packet] {
        packets.sorted(by: comparePackets)
    }

    func determineDecoderKey(in packets: [Packet]) -> Int {
        let dividerIndices = packets.indices.filter { index in
            packets[index] == [dividerPacketOne] ||
            packets[index] == [dividerPacketTwo]
        }
        assert(dividerIndices.count == 2)
        // Packet indices are 1-based so we should adjust.
        return (dividerIndices[0] + 1) * (dividerIndices[1] + 1)
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
        static var value: AnyParserPrinter<Substring, Value> {
            OneOf {
                Int.parser().map(.case(Value.int))
                Lazy { list.map(.case(Value.list)) }
            }
            .eraseToAnyParserPrinter()
        }

        static var list: AnyParserPrinter<Substring, [Value]> {
            ParsePrint {
                "["
                Many { value } separator: { "," }
                "]"
            }
            .eraseToAnyParserPrinter()
        }

        static let packetPair = ParsePrint {
            list
            Whitespace(1, .vertical)
            list
        }.map { (left: $0, right: $1) }

        static let packets = Many {
            list
        } separator: {
            Whitespace(1, .vertical)
        }

        static let input = Many {
            packetPair
        } separator: {
            Whitespace(2, .vertical)
        }
    }
}
