import Foundation
import Overture
import Parsing

struct Day06: Solution {
    func runPartOne(input: Data) async throws -> String {
        String(scanForDistinctCharacterGroup(in: utf8String(from: input), size: 4))
    }

    func runPartTwo(input: Data) async throws -> String {
        String(scanForDistinctCharacterGroup(in: utf8String(from: input), size: 14))
    }

    private func scanForDistinctCharacterGroup(in string: String, size: Int) -> Int {
        (size...string.count).first { offset in
            let upperBound = string.index(string.startIndex, offsetBy: offset)
            let lowerBound = string.index(upperBound, offsetBy: -size)
            let chars = string[lowerBound..<upperBound]
            return Set(chars).count == size
        }!
    }
}
