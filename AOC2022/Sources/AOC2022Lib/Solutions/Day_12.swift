import Foundation
import Overture
import Parsing

struct Day12: Solution {
    typealias Grid = [[Character]]
    
    struct Point: Hashable {
        let x: Int
        let y: Int
    }
    
    func runPartOne(input: Data) async throws -> String {
        pipe(
            utf8String,
            parseInput,
            findShortestRoute,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        throw NotImplemented()
    }
    
    func findStartAndFinish(in grid: Grid) -> (start: Point, finish: Point) {
        var start: Point?
        var finish: Point?
        for rowIndex in grid.indices {
            for charIndex in grid[rowIndex].indices {
                if grid[rowIndex][charIndex] == "S" {
                    start = Point(x: charIndex, y: rowIndex)
                }
                if grid[rowIndex][charIndex] == "E" {
                    finish = Point(x: charIndex, y: rowIndex)
                }
            }
        }
        return (start: start!, finish: finish!)
    }
    
    func findShortestRoute(in grid: Grid) -> Int {
        let coords = findStartAndFinish(in: grid)
        // dijktstra
        let allPoints = pointsInGrid(grid)
        var distances: [Point: Int] = [coords.start: 0]
        var queue = PriorityQueue<Point> {
            distances[$0, default: .max] < distances[$1, default: .max]
        }
        queue.enqueue(coords.start)
        
        while let node = queue.dequeue() {
            guard node != coords.finish else { break }
            
            let nodeValue = lookupValue(in: grid, at: node)
            
            let neighbours: Set<Point> = [
                .init(x: node.x + 1, y: node.y),
                .init(x: node.x, y: node.y + 1),
                .init(x: node.x - 1, y: node.y),
                .init(x: node.x, y: node.y - 1)
            ]
            
            guard let currentNodeDistance = distances[node] else {
                fatalError("Could not find distance for current node.")
            }
            
            for neighbour in neighbours {
                guard allPoints.contains(neighbour) else { continue }
                
                let value = lookupValue(in: grid, at: neighbour)
                
                // Check we are permitted to move in this direction.
                guard value <= nodeValue + 1 else { continue }
                
                let distanceThroughCurrent = currentNodeDistance + 1
                
                if distanceThroughCurrent < distances[neighbour, default: .max] {
                    distances[neighbour] = distanceThroughCurrent
                    
                    if let index = queue.index(of: neighbour) {
                        queue.changePriority(index: index, value: neighbour)
                    } else {
                        queue.enqueue(neighbour)
                    }
                }
            }
        }
        
        return distances[coords.finish]!
    }
    
    func lookupValue(in grid: Grid, at point: Point) -> Int {
        var char = grid[point.y][point.x]
        if char == "S" {
            char = "a" // we always start at the lowest point
        } else if char == "E" {
            char = "z" // and finish at the highest point
        }
        // We can use the ascii value as a basic way of assigning numeric value.
        return Int(char.asciiValue!)
    }
    
    func pointsInGrid(width: Int, height: Int) -> Set<Point> {
        Set((0..<width).flatMap { x in
            (0..<height).map { y -> Point in
                    .init(x: x, y: y)
            }
        })
    }
    
    func pointsInGrid(_ grid: Grid) -> Set<Point> {
        pointsInGrid(width: grid[0].count, height: grid.count)
    }
    
    func parseInput(_ input: String) -> Grid {
        input.components(separatedBy: .newlines).map { Array($0) }
    }
}
