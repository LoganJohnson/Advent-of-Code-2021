import Foundation

public func day2() {
    let input = parseInputToStringAndInt(fileName: "day-2")
    
    executeAnswer(dayValue: "Day2A", operation: getDay2A(inputs:), input: input)
    executeAnswer(dayValue: "Day2B", operation: getDay2B(inputs:), input: input)
}

// Basic position increase/decrease based on commands
func getDay2A(inputs: [(String, Int)]) -> Int {
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
func getDay2B(inputs: [(String, Int)]) -> Int {
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
