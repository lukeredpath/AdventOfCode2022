import Foundation
import Overture
import Parsing

struct Day03: Solution {
    func runPartOne(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        return pipe(
            parseInput,
            findErrors(in:),
            calculatePriorityScore(for:),
            String.init
        )(inputString)
    }

    func runPartTwo(input: Data) async throws -> String {
        let inputString = String(data: input, encoding: .utf8)!
        return pipe(
            parseInput,
            findElfGroups(in:),
            findBadges(in:),
            calculatePriorityScore(for:),
            String.init
        )(inputString)
    }
    
    typealias Rucksack = (left: Set<Character>, right: Set<Character>)
    
    func parseInput(_ input: String) -> [Rucksack] {
        input.components(separatedBy: .newlines).compactMap { line -> Rucksack? in
            guard !line.isEmpty else { return nil }
            let midIndex = line.index(line.startIndex, offsetBy: (line.count / 2))
            let leftChars = Array(line[line.startIndex..<midIndex])
            let rightChars = Array(line[midIndex..<line.endIndex])
            return (left: Set(leftChars), right: Set(rightChars))
        }
    }
    
    func findErrors(in rucksacks: [Rucksack]) -> [Character] {
        rucksacks.reduce([]) { partialResult, rucksack in
            partialResult + rucksack.left.intersection(rucksack.right)
        }
    }
    
    func calculatePriorityScore(for characters: [Character]) -> Int {
        // Because I'm lazy and cannot be bothered to hand-write a map of
        // characters to score values, I can cheat and take advantage of the
        // character's ascii value with an offset.
        characters.reduce(0) { partialResult, character in
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
    
    func findElfGroups(in rucksacks: [Rucksack]) -> [[Rucksack]] {
        stride(from: rucksacks.startIndex, to: rucksacks.endIndex, by: 3).map { index in
            var upperBound = index + 2
            if upperBound > rucksacks.count {
                upperBound = rucksacks.indices.upperBound
            }
            return Array(rucksacks[index...upperBound])
        }
    }
    
    func findBadges(in elfGroups: [[Rucksack]]) -> [Character] {
        elfGroups.reduce([]) { partialResult, rucksacks in
            guard rucksacks.count > 0 else { return partialResult }
            return partialResult + rucksacks.dropFirst().reduce(uniqueContents(of: rucksacks[0])) {
                $0.intersection(uniqueContents(of: $1))
            }
        }
    }
    
    private func uniqueContents(of rucksack: Rucksack) -> Set<Character> {
        rucksack.left.union(rucksack.right)
    }
}
