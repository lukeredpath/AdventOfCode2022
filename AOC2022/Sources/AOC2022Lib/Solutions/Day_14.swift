import Foundation
import Overture
import Parsing

struct Day14: Solution {
    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    enum Node {
        case rock
        case sand
    }

    typealias NodeMap = [Point: Node]

    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            generateRockMap,
            with(.init(x: 500, y: 0), flip(curry(simulateGrains))),
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }

    func generateRockMap(paths: [[Point]]) -> NodeMap {
        paths.reduce(into: [:]) { partialResult, path in
            partialResult = tracePath(path, on: partialResult, as: .rock)
        }
    }

    func simulateGrains(on map: NodeMap, startingPoint: Point) -> Int {
        var map = map
        var grainCount: Int = 0
        var reachedAbyss = false
        while !reachedAbyss {
            let previousMap = map
            map = simulateSand(on: map, startingPoint: startingPoint)
            if map == previousMap {
                reachedAbyss = true
            } else {
                grainCount += 1
            }
        }
        return grainCount
    }

    func simulateSand(on map: NodeMap, startingPoint: Point) -> NodeMap {
        var map = map
        // We pass the point of the lowest rock as the threshold for the
        // next step as any point below that will result in the sand falling
        // into the "abyss".
        let lowestRock = lowestRock(in: map)
        var currentPoint = startingPoint
        while let nextPoint = nextStep(on: map, from: currentPoint, threshold: lowestRock) {
            currentPoint = nextPoint
        }
        // We need to double-check the current point is not on the same level as the
        // lowest rock - if it is, we should let it fall into the abyss.
        if currentPoint.y < lowestRock.y {
            map[currentPoint] = .sand
        }
        return map
    }

    private func nextStep(on map: NodeMap, from point: Point, threshold: Point) -> Point? {
        let candidates: [Point] = [
            Point(x: point.x, y: point.y + 1), // down
            Point(x: point.x - 1, y: point.y + 1), // down/left
            Point(x: point.x + 1, y: point.y + 1) // down/right
        ]
        return candidates.first {
            // Any node that does not contain rock or sand and is not
            // below the threshold (the lowest rock) is suitable.
            !map.keys.contains($0) && $0.y <= threshold.y
        }
    }

    func tracePath(_ points: [Point], on map: NodeMap, as nodeType: Node) -> NodeMap {
        guard points.count >= 2 else {
            assertionFailure("At least two points required.")
            return map
        }
        return (1..<points.indices.upperBound).reduce(into: map) { map, index in
            traceNodes(on: &map, from: points[index-1], to: points[index], as: nodeType)
        }
    }

    func traceNodes(
        on map: inout NodeMap,
        from pointA: Point,
        to pointB: Point,
        as nodeType: Node
    ) {
        if pointA.x == pointB.x {
            // vertical line
            let lowerBound = min(pointA.y, pointB.y)
            let upperBound = max(pointA.y, pointB.y)
            for y in (lowerBound...upperBound) {
                map[.init(x: pointA.x, y: y)] = nodeType
            }
        } else if pointA.y == pointB.y {
            // horizontal line
            let lowerBound = min(pointA.x, pointB.x)
            let upperBound = max(pointA.x, pointB.x)
            for x in (lowerBound...upperBound) {
                map[.init(x: x, y: pointA.y)] = nodeType
            }
        }
    }

    private func lowestRock(in map: NodeMap) -> Point {
        map.keys.filter { map[$0] == .rock }.sorted { $0.y < $1.y }.last!
    }

    func printMap(_ map: NodeMap) -> String {
        let sortedX = map.keys.sorted { $0.x < $1.x }
        let xBounds = (sortedX.first!.x...sortedX.last!.x)
        let sortedY = map.keys.sorted { $0.y < $1.y }
        let yBounds = (sortedY.first!.y...sortedY.last!.y)
        var output = ""
        for y in yBounds {
            for x in xBounds {
                let point = Point(x: x, y: y)
                switch map[point] {
                case .sand:
                    output.append("o")
                case .rock:
                    output.append("#")
                case .none:
                    output.append(".")
                }
            }
            output.append("\n")
        }
        return output
    }

    enum Parsers {
        static let point = Parse {
            Int.parser()
            ","
            Int.parser()
        }.map(Point.init)

        static let path = Many {
            point
        } separator: {
            " -> "
        }

        static let input = Many {
            path
        } separator: {
            Whitespace(1, .vertical)
        }
    }
}
