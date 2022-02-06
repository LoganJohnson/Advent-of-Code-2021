import Foundation

internal func performDay2A(fileName: String) -> Int {
    return solveDay2A(inputs: parseInputToStringAndInt(fileName: fileName))
}

internal func performDay2B(fileName: String) -> Int {
    return solveDay2B(inputs: parseInputToStringAndInt(fileName: fileName))
}

// Basic position increase/decrease based on commands
private func solveDay2A(inputs: [(String, Int)]) -> Int {
    var horizontalPosition = 0
    var verticalPosition = 0
    
    for input in inputs {
        switch input.0 {
        case "forward":
            horizontalPosition += input.1
        case "down":
            verticalPosition += input.1
        case "up":
            verticalPosition -= input.1
        default:
            fatalError("getDay2A got unrecognized command: \(input.1)")
        }
    }
    
    return horizontalPosition * verticalPosition
}

// Position increase decrease with up/down controlling "aim" which only affects vertical postion when moving forward
private func solveDay2B(inputs: [(String, Int)]) -> Int {
    var horizontalPosition = 0
    var verticalPosition = 0
    var aim = 0
    
    for input in inputs {
        switch input.0 {
        case "forward":
            horizontalPosition += input.1
            verticalPosition += input.1 * aim
        case "down":
            aim += input.1
        case "up":
            aim -= input.1
        default:
            fatalError("getDay2B got unrecognized command: \(input.1)")
        }
    }
    
    return horizontalPosition * verticalPosition
}
