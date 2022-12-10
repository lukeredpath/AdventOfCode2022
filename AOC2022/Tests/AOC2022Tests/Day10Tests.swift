import CustomDump
import XCTest

@testable import AOC2022Lib

final class Day10Tests: XCTestCase {
    let sampleInput = """
    addx 15
    addx -11
    addx 6
    addx -3
    addx 5
    addx -1
    addx -8
    addx 13
    addx 4
    noop
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx -35
    addx 1
    addx 24
    addx -19
    addx 1
    addx 16
    addx -11
    noop
    noop
    addx 21
    addx -15
    noop
    noop
    addx -3
    addx 9
    addx 1
    addx -3
    addx 8
    addx 1
    addx 5
    noop
    noop
    noop
    noop
    noop
    addx -36
    noop
    addx 1
    addx 7
    noop
    noop
    noop
    addx 2
    addx 6
    noop
    noop
    noop
    noop
    noop
    addx 1
    noop
    noop
    addx 7
    addx 1
    noop
    addx -13
    addx 13
    addx 7
    noop
    addx 1
    addx -33
    noop
    noop
    noop
    addx 2
    noop
    noop
    noop
    addx 8
    noop
    addx -1
    addx 2
    addx 1
    noop
    addx 17
    addx -9
    addx 1
    addx 1
    addx -3
    addx 11
    noop
    noop
    addx 1
    noop
    addx 1
    noop
    noop
    addx -13
    addx -19
    addx 1
    addx 3
    addx 26
    addx -30
    addx 12
    addx -1
    addx 3
    addx 1
    noop
    noop
    noop
    addx -9
    addx 18
    addx 1
    addx 2
    noop
    noop
    addx 9
    noop
    noop
    noop
    addx -1
    addx 2
    addx -37
    addx 1
    addx 3
    noop
    addx 15
    addx -21
    addx 22
    addx -6
    addx 1
    noop
    addx 2
    addx 1
    noop
    addx -10
    noop
    noop
    addx 20
    addx 1
    addx 2
    addx 2
    addx -6
    addx -11
    noop
    noop
    noop
    
    """
    
    let solution = Day10()
    
    func testSmallProgram() {
        let program: [Day10.Instruction] = [
            .noop,
            .addx(3),
            .addx(-5)
        ]
        
        let cycleValues = solution.captureCycles([1, 2, 3, 4, 5, 6], instructions: program)
        
        XCTAssertNoDifference(cycleValues, [
            1: 1,
            2: 1,
            3: 1,
            4: 4,
            5: 4
        ])
        
        let signalStrengths = solution.calculateSignalStrength(cycleValues)
        
        XCTAssertNoDifference(signalStrengths, [
            1: 1,
            2: 2,
            3: 3,
            4: 16,
            5: 20
        ])
    }
    
    func testLongerExample() throws {
        let input = try Day10.Parsers.input.parse(sampleInput.trimmingCharacters(in: .newlines))
        let cycleValues = solution.captureCycles([20, 60, 100, 140, 180, 220], instructions: input)
        let signalStrengths = solution.calculateSignalStrength(cycleValues)
        XCTAssertNoDifference(signalStrengths, [
            20: 420,
            60: 1140,
            100: 1800,
            140: 2940,
            180: 2880,
            220: 3960
        ])
    }
    
    func testPixelCapture() throws {
        let input = try Day10.Parsers.input.parse(sampleInput.trimmingCharacters(in: .newlines))
        let pixelValues = solution.captureScreenOutput(instructions: input)
        XCTAssertEqual(240, pixelValues.count)
        
        let rendering = solution.printPixels(pixelValues)
        XCTAssertNoDifference(rendering, """
        ##..##..##..##..##..##..##..##..##..##..
        ###...###...###...###...###...###...###.
        ####....####....####....####....####....
        #####.....#####.....#####.....#####.....
        ######......######......######......###.
        #######.......#######.......#######.....
        
        """)
    }
    
    func testSampleSolution_PartOne() async throws {
        let solution = Day10()
        let answer = try await solution.runPartOne(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "13140")
    }
    
    func _testSampleSolution_PartTwo() async throws {
        let solution = Day10()
        let answer = try await solution.runPartTwo(input: sampleInput.data(using: .utf8)!)
        XCTAssertEqual(answer, "")
    }
}
