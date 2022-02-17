import Foundation

private enum AdjacentDireciton: CaseIterable {
    case top
    case right
    case bottom
    case left
}

private struct Coordinate: Hashable {
    var xCoord: Int
    var yCoord: Int
    var height: Int
}

// https://adventofcode.com/2021/day/9
internal func performDay9A(file: String) -> Int {
    solveDay9A(intGrid: parseIntGrid(file: file))
}

// https://adventofcode.com/2021/day/9#part2
internal func performDay9B(file: String) -> Int {
    solveDay9B(intGrid: parseIntGrid(file: file))
}

// find low points, answer is sum of all low points, each with an additional + 1
private func solveDay9A(intGrid: [[Int]]) -> Int {
    let allLowPointCoordinates = findAllLowPointCoordinates(intGrid: intGrid)
    
    return allLowPointCoordinates.count + allLowPointCoordinates.map({ $0.height }).reduce(0) { $0 + $1 }
}

// find size of "basins", answer is 3 largest basins multiplied together
private func solveDay9B(intGrid: [[Int]]) -> Int {
    let allLowPointCoordinates = findAllLowPointCoordinates(intGrid: intGrid)
    
    var basinSizes = [Int]()
    
    for lowPointCoordinate in allLowPointCoordinates {
        guard let mappedCoords = traverseBasin(currentCoord: lowPointCoordinate, mappedCoords: Set<Coordinate>(), intGrid: intGrid) else { continue }
        
        basinSizes.append(mappedCoords.count)
    }
    
    // multiply the largest 3 values together
    return basinSizes.sorted(by: >)[0...2].reduce(1) { $0 * $1 }
}

private func findAllLowPointCoordinates(intGrid: [[Int]]) -> Set<Coordinate> {
    var lowPointCoordinates = Set<Coordinate>()
    
    for (currentYCoord, row) in intGrid.enumerated() {
        for (currentXCoord, height) in row.enumerated() {
            let currentCoordinate = Coordinate(xCoord: currentXCoord, yCoord: currentYCoord, height: height)
            
            var foundALowerPoint = false
            for direction in AdjacentDireciton.allCases {
                if let adjacentCoordinate = getAdjacentCoordinate(currentCoord: currentCoordinate,
                                                                  direction: direction,
                                                                  intGrid: intGrid) {
                    // even if heights are the same, this is considers a "lower point"
                    if adjacentCoordinate.height <= currentCoordinate.height {
                        foundALowerPoint = true
                        break
                    }
                }
            }
            
            if !foundALowerPoint {
                // no adjacent lower spot found, this is a low point
                lowPointCoordinates.insert(currentCoordinate)
            }
        }
    }
    
    return lowPointCoordinates
}

private func traverseBasin(currentCoord: Coordinate, mappedCoords: Set<Coordinate>, intGrid: [[Int]]) -> Set<Coordinate>? {
    // if we already have this coordinate mapped, ignore it
    if mappedCoords.contains(currentCoord) { return nil }
    
    // 9s are not added to basins and can be ignored
    if currentCoord.height == 9 { return nil }
    
    var newMappedCoords = mappedCoords
    newMappedCoords.insert(currentCoord)
    
    for direction in AdjacentDireciton.allCases {
        guard let adjacentCoord = getAdjacentCoordinate(currentCoord: currentCoord, direction: direction, intGrid: intGrid) else { continue }
        guard let additionalMappedCoordinates = traverseBasin(currentCoord: adjacentCoord, mappedCoords: newMappedCoords, intGrid: intGrid) else { continue }
        
        for additionalMappedCoordinate in additionalMappedCoordinates {
            newMappedCoords.insert(additionalMappedCoordinate)
        }
    }
    
    return newMappedCoords
}

private func getAdjacentCoordinate(currentCoord: Coordinate, direction: AdjacentDireciton, intGrid: [[Int]]) -> Coordinate? {
    let validXRange = 0...intGrid[0].count - 1
    let validYRange = 0...intGrid.count - 1
    
    // keep in mind that the 2D array is Y/X based, not X/Y
    switch direction {
        case .top:
            let topYCoord = currentCoord.yCoord - 1
            if validYRange.contains(topYCoord) {
                return Coordinate(xCoord: currentCoord.xCoord,
                                  yCoord: topYCoord,
                                  height: intGrid[topYCoord][currentCoord.xCoord])
            }
        case .right:
            let rightXCoord = currentCoord.xCoord + 1
            if validXRange.contains(rightXCoord) {
                return Coordinate(xCoord: rightXCoord,
                                  yCoord: currentCoord.yCoord,
                                  height: intGrid[currentCoord.yCoord][rightXCoord])
            }
        case .bottom:
            let bottomYCoord = currentCoord.yCoord + 1
            if validYRange.contains(bottomYCoord) {
                return Coordinate(xCoord: currentCoord.xCoord,
                                  yCoord: bottomYCoord,
                                  height: intGrid[bottomYCoord][currentCoord.xCoord])
            }
        case .left:
            let leftXCoord = currentCoord.xCoord - 1
            if validXRange.contains(leftXCoord) {
                return Coordinate(xCoord: leftXCoord,
                                  yCoord: currentCoord.yCoord,
                                  height: intGrid[currentCoord.yCoord][leftXCoord])
            }
    }
    
    // not a valid coordinate
    return nil
}
