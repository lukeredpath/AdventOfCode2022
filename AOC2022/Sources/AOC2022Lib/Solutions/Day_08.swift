import Foundation
import Overture
import Parsing

struct Day08: Solution {
    func runPartOne(input: Data) async throws -> String {
        pipe(
            utf8String,
            parseInput,
            countVisible,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        pipe(
            utf8String,
            parseInput,
            findHighestScenicScore,
            String.init
        )(input)
    }
    
    struct Grid: Equatable {
        var rows: [[Int]] = []
        private var rowCount: Int
        private var colCount: Int
        
        var rowUpperBound: Int { rowCount - 1 }
        var colUpperBound: Int { colCount - 1 }
        
        init(rowCount: Int, colCount: Int) {
            self.rowCount = rowCount
            self.colCount = colCount
            rows = Array(repeating: Array(repeating: 0, count: colCount), count: rowCount)
        }
        
        init(rows: [[Int]]) {
            guard !rows.isEmpty, Set(rows.map(\.count)).count == 1 else {
                fatalError("Rows must not be empty and must all contain the same number of values.")
            }
            self.rowCount = rows.count
            self.colCount = rows[0].count
            self.rows = rows
        }
        
        func isVisible(atRow rowIndex: Int, col colIndex: Int) -> Bool {
            guard rowIndex < rowCount, colIndex < colCount else {
                fatalError("(\(rowIndex), \(colIndex)) is out of bounds.")
            }
            // All perimeter trees are visible.
            if rowIndex == 0 || rowIndex == rowUpperBound || colIndex == 0 || colIndex == colUpperBound {
                return true
            }
            // Otherwise, we need to look across the row and col in both directions.
            let height = rows[rowIndex][colIndex]
            // Look up
            if (0..<rowIndex).allSatisfy({ rows[$0][colIndex] < height }) {
                return true
            }
            // Look down
            if (rowIndex + 1...rowUpperBound).allSatisfy({ rows[$0][colIndex] < height }) {
                return true
            }
            // Look left
            if (0..<colIndex).allSatisfy({ rows[rowIndex][$0] < height }) {
                return true
            }
            // Look right
            if (colIndex + 1...colUpperBound).allSatisfy({ rows[rowIndex][$0] < height }) {
                return true
            }
            return false
        }
        
        func sceneScore(atRow rowIndex: Int, col colIndex: Int) -> Int {
            guard rowIndex < rowCount, colIndex < colCount else {
                fatalError("(\(rowIndex), \(colIndex)) is out of bounds.")
            }
            // All perimeter trees will have a score of zero.
            if rowIndex == 0 || rowIndex == rowUpperBound || colIndex == 0 || colIndex == colUpperBound {
                return 0
            }
            let height = rows[rowIndex][colIndex]
            let upCount = countVisible(
                height: height,
                rowIndices: Array(0..<rowIndex).reversed(),
                col: colIndex
            )
            let downCount = countVisible(
                height: height,
                rowIndices: Array(rowIndex + 1...rowUpperBound),
                col: colIndex
            )
            let leftCount = countVisible(
                height: height,
                colIndices: Array(0..<colIndex).reversed(),
                row: rowIndex
            )
            let rightCount = countVisible(
                height: height,
                colIndices: Array(colIndex + 1...colUpperBound),
                row: rowIndex
            )
            return (upCount * downCount * leftCount * rightCount)
        }
        
        private func countVisible(height: Int, rowIndices: [Int], col colIndex: Int) -> Int {
            var count: Int = 0
            for rowIndex in rowIndices {
                let thisHeight = rows[rowIndex][colIndex]
                if thisHeight < height {
                    count += 1
                } else {
                    count += 1
                    break
                }
            }
            return count
        }
        
        private func countVisible(height: Int, colIndices: [Int], row rowIndex: Int) -> Int {
            var count: Int = 0
            for colIndex in colIndices {
                let thisHeight = rows[rowIndex][colIndex]
                if thisHeight < height {
                    count += 1
                } else {
                    count += 1
                    break
                }
            }
            return count
        }
    }
    
    func countVisible(in grid: Grid) -> Int {
        (0...grid.rowUpperBound).reduce(into: 0) { count, rowIndex in
            count = (0...grid.colUpperBound).reduce(into: count) { count, colIndex in
                if grid.isVisible(atRow: rowIndex, col: colIndex) {
                    count += 1
                }
            }
        }
    }
    
    func findHighestScenicScore(in grid: Grid) -> Int {
        let scores = (0...grid.rowUpperBound).flatMap { rowIndex in
            (0...grid.colUpperBound).map { colIndex in
                grid.sceneScore(atRow: rowIndex, col: colIndex)
            }
        }
        return scores.sorted().last!
    }
    
    func parseInput(_ input: String) -> Grid {
        Grid(rows: input.components(separatedBy: .newlines).compactMap { rowString in
            guard !rowString.isEmpty else { return nil }
            return Array(rowString).compactMap { Int(String($0)) }
        })
    }
}
