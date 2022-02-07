import Foundation

// https://adventofcode.com/2021/day/1
internal func performDay1A(fileName: String) -> Int {
    return solveDay1A(inputs: parseInputToInts(fileName: fileName))
}

// https://adventofcode.com/2021/day/1#part2
internal func performDay1B(fileName: String) -> Int {
    return solveDay1B(inputs: parseInputToInts(fileName: fileName))
}

// Simple sum of values that are larger than previous value
private func solveDay1A(inputs: [Int]) -> Int {
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
private func solveDay1B(inputs: [Int]) -> Int {
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
