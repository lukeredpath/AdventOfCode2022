import Foundation
import Overture
import Parsing

struct Day03: Solution {
    func runPartOne(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        let transform: (String) -> String = pipe(
            parseInput,
            findErrors(in:),
            calculatePriorityScore(for:),
            String.init
        )
        return transform(inputString)
    }

    func runPartTwo(input: Data) async throws -> String {
//        let inputString = String(data: input, encoding: .utf8)!
        return ""
    }
    
    typealias Rucksack = (left: Set<Character>, right: Set<Character>)
    
    func parseInput(_ input: String) -> [Rucksack] {
        input.components(separatedBy: .newlines).map { line -> Rucksack in
            let midIndex = line.index(line.startIndex, offsetBy: (line.count / 2))
            let leftChars = Array(line[line.startIndex..<midIndex])
            let rightChars = Array(line[midIndex..<line.endIndex])
            return (left: Set(leftChars), right: Set(rightChars))
        }
    }
    
    func findErrors(in rucksacks: [Rucksack]) -> [Character] {
        let errors = rucksacks.reduce([]) { partialResult, rucksack in
            partialResult + rucksack.left.intersection(rucksack.right)
        }
        return errors
    }
    
    func calculatePriorityScore(for errors: [Character]) -> Int {
        // Because I'm lazy and cannot be bothered to hand-write a map of
        // characters to score values, I can cheat and take advantage of the
        // character's ascii value with an offset.
        errors.reduce(0) { partialResult, character in
            // Let's be safe and check for valid input
            guard character.isASCII, let asciiValue = character.asciiValue else {
                return partialResult
            }
            if character.isLowercase {
                // lowercase letters: 97-122 >>> 1-26
                return partialResult + Int(asciiValue) - 96
            } else {
                // uppercase letters: 65-90 >>> 27-52
                return partialResult + Int(asciiValue) - 38
            }
        }
    }
}
