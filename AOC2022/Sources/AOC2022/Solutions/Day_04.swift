import Foundation
import Overture
import Parsing

struct Day04: Solution {
    func runPartOne(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            countFullyContainedAssignments,
            String.init
        )(input)
    }

    func runPartTwo(input: Data) async throws -> String {
        try pipe(
            utf8String,
            Parsers.input.parse,
            countOverlappingAssignments,
            String.init
        )(input)
    }
    
    typealias Assignment = ClosedRange<Int>
    
    func countFullyContainedAssignments(in pairs: [(Assignment, Assignment)]) -> Int {
        pairs.filter { pair in
            pair.0.fullyContains(pair.1) || pair.1.fullyContains(pair.0)
        }.count
    }
    
    func countOverlappingAssignments(in pairs: [(Assignment, Assignment)]) -> Int {
        pairs.filter { pair in
            pair.0.overlaps(pair.1) || pair.1.overlaps(pair.0)
        }.count
    }
    
    enum Parsers {
        static let assignment = Parse {
            Int.parser()
            "-"
            Int.parser()
        }.map(Assignment.init(uncheckedBounds:))
        
        static let assignmentPair = Parse {
            assignment
            ","
            assignment
        }
        
        static let input = Many {
            assignmentPair
        } separator: {
            Whitespace(1, .vertical)
        }
    }
}

extension ClosedRange {
    func fullyContains(_ otherRange: Self) -> Bool {
        lowerBound <= otherRange.lowerBound && upperBound >= otherRange.upperBound
    }
}
