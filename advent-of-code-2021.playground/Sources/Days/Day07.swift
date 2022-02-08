import Foundation

// https://adventofcode.com/2021/day/7
internal func performDay7A(fileName: String) -> Int {
    return solveDay7A(horizontalPositions: parseInputCommaSeparatedInts(fileName: fileName))
}

private func solveDay7A(horizontalPositions: [Int]) -> Int {
    var leastFuelSpent = -1
    
    for horizontalPosition in horizontalPositions {
        let fuelSpent = horizontalPositions.map({ abs($0 - horizontalPosition) }).reduce(0) { $0 + $1 }
        
        if fuelSpent < leastFuelSpent || leastFuelSpent == -1 {
            leastFuelSpent = fuelSpent
        }
    }
    
    return leastFuelSpent
}
