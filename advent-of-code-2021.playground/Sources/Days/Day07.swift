import Foundation

// https://adventofcode.com/2021/day/7
internal func performDay7A(fileName: String) -> Int {
    return solveDay7A(positions: parseInputCommaSeparatedInts(fileName: fileName))
}

// https://adventofcode.com/2021/day/7#part2
internal func performDay7B(fileName: String) -> Int {
    return solveDay7B(positions: parseInputCommaSeparatedInts(fileName: fileName))
}

private func solveDay7A(positions: [Int]) -> Int {
    // median will be the most efficient since each position move counts as 1
    getFuelEfficiency7A(positions: positions, positionToMoveTo: positions.median)
}

private func solveDay7B(positions: [Int]) -> Int {
    var leastFuelSpent = -1
    
    // uniqify the positions to loop over, still use duplicates array to get fuel efficiency though
    for position in Array(Set(positions)).sorted(by: <) {
        let fuelSpent = getFuelEfficiency7B(positions: positions, positionToMoveTo: position)
        
        if fuelSpent < leastFuelSpent || leastFuelSpent == -1 {
            leastFuelSpent = fuelSpent
        } else {
            // if we encounter a fuel efficiency that is worse, that means we are past the "peak" efficiency
            break
        }
    }
    
    return leastFuelSpent
}

// each horizontal increment only uses a single unit of fuel
private func getFuelEfficiency7A(positions: [Int], positionToMoveTo: Int) -> Int {
    positions.map({ abs($0 - positionToMoveTo) }).reduce(0) { $0 + $1 }
}

// each horizontal increment is 1 more expensive than the last
private func getFuelEfficiency7B(positions: [Int], positionToMoveTo: Int) -> Int {
    positions.map({ abs($0 - positionToMoveTo).plusEachLowerNumber }).reduce(0) { $0 + $1 }
}
