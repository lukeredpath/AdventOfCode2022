public enum Solution: Int {
    case one = 1
    case two
}

public func notImplemented() {
    print("Solution not yet implemented")
}

public func runSolution(_ solution: Solution) async throws {
    switch solution {
    case .one:
        try await Day01.run()
    case .two:
        try await Day02.run()
    }
}
