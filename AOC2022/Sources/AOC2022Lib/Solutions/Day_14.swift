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
            simulateGrainsPartOne,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            generateRockMap,
            simulateGrainsPartTwo,
            String.init
        )(input)
    }

    func generateRockMap(paths: [[Point]]) -> NodeMap {
        paths.reduce(into: [:]) { partialResult, path in
            partialResult = tracePath(path, on: partialResult, as: .rock)
        }
    }

    func simulateGrainsPartOne(on map: NodeMap) -> Int {
        simulateGrains(
            on: map,
            startingPoint: .init(x: 500, y: 0),
            floor: lowestRock(in: map).y
        )
    }

    func simulateGrainsPartTwo(on map: NodeMap) -> Int {
        simulateGrains(
            on: map,
            startingPoint: .init(x: 500, y: 0),
            floor: lowestRock(in: map).y + 2,
            canFallThroughFloor: false
        )
    }

    func simulateGrains(
        on map: NodeMap,
        startingPoint: Point,
        floor: Int,
        canFallThroughFloor: Bool = true
    ) -> Int {
        var map = map
        while true {
            if !simulateSand(on: &map, startingPoint: startingPoint, floor: floor, canFallThroughFloor: canFallThroughFloor) {
                break
            }
        }
        return map.filter { $0.value == .sand }.count
    }

    func simulateSand(
        on map: inout NodeMap,
        startingPoint: Point,
        floor: Int,
        canFallThroughFloor: Bool
    ) -> Bool {
        var currentPoint = startingPoint
        while let nextPoint = nextStep(on: map, from: currentPoint, yThreshold: floor) {
            currentPoint = nextPoint
        }
        if currentPoint == startingPoint {
            // The starting point is now blocked and no more sand can come to a rest.
            map[currentPoint] = .sand
            return false
        }
        if currentPoint.y == floor && canFallThroughFloor {
            // If we've reached the lowest rocks the sand will fall through into the abyss.
            return false
        }
        if currentPoint.y == floor {
            // Otherwise we've reached the real floor, so the grain will rest on the
            // point directly above.
            currentPoint = .init(x: currentPoint.x, y: currentPoint.y - 1)
        }
        map[currentPoint] = .sand
        return true
    }

    private func nextStep(on map: NodeMap, from point: Point, yThreshold: Int) -> Point? {
        let candidates: [Point] = [
            Point(x: point.x, y: point.y + 1), // down
            Point(x: point.x - 1, y: point.y + 1), // down/left
            Point(x: point.x + 1, y: point.y + 1) // down/right
        ]
        return candidates.first {
            // Any node that does not contain rock or sand and is
            // at or above the y threshold is a valid candidate.
            return !map.keys.contains($0) && $0.y <= yThreshold
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

    func lowestRock(in map: NodeMap) -> Point {
        map.keys.filter { map[$0] == .rock }.sorted { $0.y < $1.y }.last!
    }

    func printMap(_ map: NodeMap, floor: Int? = nil) -> String {
        let sortedX = map.keys.sorted { $0.x < $1.x }
        let sortedY = map.keys.sorted { $0.y < $1.y }
        let xBounds: ClosedRange<Int>
        let yBounds: ClosedRange<Int>
        if let floor {
            xBounds = (sortedX.first!.x-2...sortedX.last!.x+2)
            yBounds = (sortedY.first!.y...floor)
        } else {
            xBounds = (sortedX.first!.x...sortedX.last!.x)
            yBounds = (sortedY.first!.y...sortedY.last!.y)
        }
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
                    if point.y == floor {
                        output.append("#")
                    } else {
                        output.append(".")
                    }
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
