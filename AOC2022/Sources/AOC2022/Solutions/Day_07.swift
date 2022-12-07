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
            findSmallDirectoryTotal,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        try pipe(
            { String(data: $0, encoding: .utf8)! },
            Parsers.input.parse,
            calculateSizeMap,
            findDeletionCandidate,
            String.init
        )(input)
    }

    enum Command: Equatable {
        case cd(String)
        case ls(output: [ListNode])
    }

    enum ListNode: Equatable {
        case dir(String)
        case file(Int, String)
    }

    struct Dir: Equatable, Hashable {
        let name: String
        let id: UUID = UUID()
    }

    func calculateSizeMap(from commands: [Command]) -> [Dir: Int] {
        var sizeMap: [Dir: Int] = [:]
        // We'll track the node path and sizes using UUIDs because
        // that guarantees a unique key for each node even if there
        // are directories with the same name at different depths.
        var path: [Dir] = []
        for command in commands {
            switch command {
            case .cd(".."):
                path.removeLast()
            case let .cd(name):
                let dir = Dir(name: name)
                path.append(dir)
                sizeMap[dir] = 0
            case let .ls(nodes):
                for node in nodes {
                    switch node {
                    case .dir: break
                    case let .file(size, _):
                        for dir in path {
                            if let currentSize = sizeMap[dir] {
                                sizeMap[dir] = currentSize + size
                            }
                        }
                    }
                }
            }
        }
        return sizeMap
    }

    func findSmallDirectoryTotal(in sizeMap: [Dir: Int]) -> Int {
        sizeMap.reduce(into: 0) { partialResult, map in
            if map.value <= 100_000 {
                partialResult += map.value
            }
        }
    }

    func findDeletionCandidate(in sizeMap: [Dir: Int]) -> Int {
        let totalSpace = 70_000_000
        let unusedSpaceRequired = 30_000_000
        // We'll assume there must always be a root
        let root = sizeMap.keys.first { $0.name == "/" }!
        let unusedSpace = totalSpace - sizeMap[root]!
        let spaceRequired = unusedSpaceRequired - unusedSpace
        return sizeMap
            .filter { $0.value >= spaceRequired }
            .sorted { $0.value < $1.value }
            .first!.value
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
