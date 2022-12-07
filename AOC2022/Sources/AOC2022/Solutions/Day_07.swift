import CustomDump
import Foundation
import Overture
import Parsing

struct Day07: Solution {
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            { String(data: $0, encoding: .utf8)! },
            Parsers.input.parse,
            calculateSizeMap,
            with(100_000, flip(curry(findSmallDirectoryTotal))),
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }

    enum Command: Equatable {
        case cd(String)
        case ls(output: [ListNode])
    }

    enum ListNode: Equatable {
        case dir(String)
        case file(Int, String)
    }

    func calculateSizeMap(from commands: [Command]) -> [UUID: Int] {
        var sizeMap: [UUID: Int] = [:]
        // We'll track the node path and sizes using UUIDs because
        // that guarantees a unique key for each node even if there
        // are directories with the same name at different depths.
        var path: [UUID] = []
        for command in commands {
            switch command {
            case .cd(".."):
                path.removeLast()
            case .cd:
                let nodeID = UUID()
                path.append(nodeID)
                sizeMap[nodeID] = 0
            case let .ls(nodes):
                for node in nodes {
                    switch node {
                    case .dir: break
                    case let .file(size, _):
                        for nodeID in path {
                            if let currentSize = sizeMap[nodeID] {
                                sizeMap[nodeID] = currentSize + size
                            }
                        }
                    }
                }
            }
        }
        return sizeMap
    }

    func findSmallDirectoryTotal(in sizeMap: [UUID: Int], limit: Int) -> Int {
        sizeMap.reduce(into: 0) { partialResult, map in
            if map.value <= limit {
                partialResult += map.value
            }
        }
    }

    enum Parsers {
        static let cd = Parse {
            "$ cd "
            PrefixUpTo("\n").map(.string)
        }
        .map(.case(Command.cd))

        static let listNode = OneOf {
            Parse {
                "dir "
                PrefixUpTo("\n").map(.string)
            }
            .map(.case(ListNode.dir))

            Parse {
                Int.parser()
                " "
                PrefixUpTo("\n").map(.string)
            }
            .map(.case(ListNode.file))
        }

        static let ls = Parse {
            "$ ls"
            Whitespace(1, .vertical)
            Many { listNode } separator: {
                Whitespace(1, .vertical)
            }
        }
        .map(.case(Command.ls))

        static let command = OneOf {
            ls
            cd
        }

        static let input = Many {
            command
        } separator: {
            Whitespace(1, .vertical)
        } terminator: {
            Whitespace(1, .vertical)
        }
    }
}
