import Foundation

public func day1() {
    let day1Input = parseInputToInts(fileName: "day-1")
    
    executeAnswer(operation: getDay1A(inputs:), input: day1Input)
    executeAnswer(operation: getDay1B(inputs:), input: day1Input)
}

// Simple sum of values that are larger than previous value
func getDay1A(inputs: [Int]) -> Int {
    var increaseCount = 0
    
    for (index, _) in inputs.enumerated() {
        guard index + 1 < inputs.count else { break }
        
        if inputs[index] < inputs[index + 1] {
            increaseCount += 1
        }
    }
    
    return increaseCount
}

// Sum of 3 day average sliding windows that increase compared to previous
func getDay1B(inputs: [Int]) -> Int {
    var increaseCount = 0
    
    for (index, _) in inputs.enumerated() {
        guard index + 3 < inputs.count else { break }
        
        let currentWindow = inputs[index] + inputs[index + 1] + inputs[index + 2]
        let nextWindow = inputs[index + 1] + inputs[index + 2] + inputs[index + 3]
        
        if currentWindow < nextWindow {
            increaseCount += 1
        }
    }
    
    return increaseCount
}
